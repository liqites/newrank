RSpec.describe Newrank do
  # describe "#document" do
  #   it "should get document" do
  #     expect(Newrank.new.document('rmrbwx').class).to eq(Nokogiri::HTML::Document)
  #   end
  # end

  # describe "#crawl" do
  #   it "should get json" do
  #     puts Newrank.new.crawl('rmrbwx')
  #   end
  # end

  # describe "#score_and_uuid" do
  #   it "should get scode and uuid" do
  #     doc = Newrank.new.document('rmrbwx')
  #     puts Newrank.new.score_and_uuid(doc)
  #   end
  # end
  #
  # describe "#week_data" do
  #   it "should get week data" do
  #     doc = Newrank.new.document('rmrbwx')
  #     puts Newrank.new.week_data(doc)
  #   end
  # end
  #
  describe "#_md5" do
    it "should get md5 string" do
      puts Newrank.new._md5("/xdnphb/detail/getAccountArticle?AppKey=joker&uuid=04205A9952E24C3292871BA9F0E2852B")
    end
  end
end
