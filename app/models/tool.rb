# == Schema Information
#
# Table name: tools
#
#  id           :bigint           not null, primary key
#  results      :json
#  search_query :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Tool < ApplicationRecord
end
