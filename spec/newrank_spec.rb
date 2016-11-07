RSpec.describe Newrank do
  describe "#document" do
    it "should get document" do
      expect(Newrank.new.document('rmrbwx').class).to eq(Nokogiri::HTML::Document)
    end
  end

  describe "#crawl" do
    it "should get json" do
      data = Newrank.new.crawl('rmrbwx')
      # puts data.keys
      # puts data[:week_data][0].keys
      # puts data[:posts_data].keys
      expect(Newrank.new.crawl('rmrbwx')[:posts_data].count).to be > 0
    end
  end

  describe "#score_and_uuid" do
    it "should get scode and uuid" do
      doc = Newrank.new.document('rmrbwx')
      sroce, uuid = Newrank.new.score_and_uuid(doc)
      expect(uuid).to eq('04205A9952E24C3292871BA9F0E2852B')
    end
  end

  describe "#week_data" do
    it "should get week data" do
      doc = Newrank.new.document('rmrbwx')
      expect(Newrank.new.week_data(doc).count).to be > 0
    end
  end

  describe "#_md5" do
    it "should get md5 string" do
      Newrank.new._md5("/xdnphb/detail/getAccountArticle?AppKey=joker&uuid=04205A9952E24C3292871BA9F0E2852B")
    end
  end

  describe "#gen_xyz" do
    it "should get correct md5 string" do
      nonce = "dd8133fd0"
      uuid = "04205A9952E24C3292871BA9F0E2852B"
      xyz = Newrank.new.gen_xyz(nonce, uuid)
      expect(xyz).to eq("0d1db7f28dfa2853c48f4873f297ae01")
    end
  end
end
