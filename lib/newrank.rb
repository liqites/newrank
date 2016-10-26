# coding: utf-8
require 'open-uri'
require 'rkelly'
require 'nokogiri'
require 'json'
require 'execjs'
require 'rest-client'

class Newrank
  # crawl newrank info
  def crawl(newrank_id)
    doc = document(newrank_id.gsub("\u{a0}",""))
    if !doc.nil?
      score, uuid = score_and_uuid(doc)

      element = doc.css(".detail-fans-counts")[0]
      active_users_count = element.nil? ? 0 : element.text.gsub(",","").to_i

      element = doc.css(".info-detail-head-weixin-fun-introduce")[0]
      introduce = element.nil? ? "" : element.text

      week_data = week_data(doc)
      if !uuid.nil?
        posts_data = fetch_post(uuid)
      end
      {
        active_users_count: active_users_count,
        score: (score || 0),
        introduce: introduce,
        week_data: week_data,
        posts_data: (posts_data || {})
      }
    else
      {
        active_users_count: 0,
        score: 0,
        introduce: "",
        week_data: [],
        posts_data: {}
      }
    end
  end
  
  # crawl posts
  def fetch_post(uuid)
    nonce = gen_nonce
		xyz = gen_xyz(nonce, uuid)

    posts = JSON.parse(RestClient.post("http://www.newrank.cn/xdnphb/detail/getAccountArticle", {uuid: uuid, nonce: nonce, xyz: xyz}, {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.106 Safari/537.36"}))
  end

  # crawl week data
  def week_data(doc)
    data = []

    if !doc.css("script")[0].nil?
      parser = RKelly::Parser.new
      ast = parser.parse(doc.css("script")[0].text.strip)
      array_node = ast.pointcut(RKelly::Nodes::ArrayNode).matches.first
      array_node.pointcut(RKelly::Nodes::ElementNode).matches.each do |element_node|
        data << JSON.parse(element_node.to_ecma)
      end
    end

    data
  end
  
  # get Nogogiri Document
  def document(newrank_account)
    url = 'http://www.newrank.cn/public/info/detail.html?account=' + newrank_account
    Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (Windows NT 6.2; rv:10.0.1) Gecko/20100101 Firefox/10.0.1", :read_timeout => 10), nil, 'utf-8')
  end
  
  # find score and uuid
  def score_and_uuid(doc)
    score, uuid = nil

    script = doc.css("script")[0]
    if !script.nil?
      parser = RKelly::Parser.new
      ast = parser.parse(script.text.strip)
      array_node = ast.pointcut(RKelly::Nodes::ArrayNode).matches.first
      element_node = array_node.pointcut(RKelly::Nodes::ElementNode).matches.first
      json_data = element_node.nil? ? {} : JSON.parse(element_node.to_ecma)
      if json_data["new_rank_index_mark"]
        score = json_data["new_rank_index_mark"].to_f
      else
        score = 0.0
      end
      object_node = ast.pointcut(RKelly::Nodes::AssignExprNode).matches[-1]
      node = object_node.pointcut(RKelly::Nodes::PropertyNode).matches.select{|n| n.name == '"uuid"'}.first.value
      uuid = node.value[1..-2]
    end

    return score, uuid
  end
  
  # wait for seconds
  # instead of request too much
  def wait_for_seconds
		sleep(1 * rand)
	end
  
  # generate parameter nonce
	def gen_nonce
		a = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a","b", "c", "d", "e", "f"]
		b = 0
		while 500 > b
			d = 0
			c = ""
			while 9 > d
				e = (16 * rand).floor
				c << a[e]
				d = d + 1
			end
			b = b + 1
		end
    c
	end
  
  # generate parameter xyz
	def gen_xyz(nonce, uuid)
    h = "/xdnphb/detail/getAccountArticle?AppKey=joker&uuid=#{uuid}&nonce=#{nonce}"
	  _md5(h)
	end
  
  # use js md5 algorightm, written by newrank, file in assets/newrank_md5.js
  def _md5(str)
    js_context.call('newrank_md5', str, bare: true)
  end
  
  # js context
  def js_context
    file_path = File.join( File.dirname(__FILE__), './assets/newrank_md5.js')
    @context ||= ExecJS.compile(File.read(file_path))
  end
  #------------------------
end
