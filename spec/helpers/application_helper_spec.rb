require 'spec_helper'

describe ApplicationHelper do

  describe '#top_menu_active?' do
    it 'returns active class for equal request path'
    it 'returns empty class for any other request path'
  end

  describe '.app_version' do
    it 'returns app version written from file'
  end

end