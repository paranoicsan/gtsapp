require 'spec_helper'

describe ApplicationHelper do

  describe '#top_menu_active?' do
    before(:each) do
      @path = 'http://test.com/main'
      @request.stub(:fullpath).and_return(@path)
    end
    it 'returns active class for equal request path' do
      helper.top_menu_active?(@path).should eq('active')
    end
    it 'returns empty class for any other request path' do
      helper.top_menu_active?('http://').should eq('')
    end
  end

  describe '.app_version' do
    it 'returns app version written from file' do
      version = ''
      File.open(ApplicationHelper::VERSION_FILE) {|f| version = f.readline}
      helper.app_version.should eq(version)
    end
  end

end