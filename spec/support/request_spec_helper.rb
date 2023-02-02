module RequestSpecHelper
  # Parse JSON response to ruby hash
  def response_body
    JSON.parse(response.body, symbolize_names: true)
  end

  def response_data
    response_body[:data]
  end

  def expect_response(status, json = nil)
    begin
      expect(response).to have_http_status(status)
    rescue RSpec::Expectations::ExpectationNotMetError => e
      e.message << "\n#{JSON.pretty_generate(response_body)}"
      raise e
    end
    expect(response_body).to be_json_type(json) if json
  end
end

RSpec::Matchers.define :be_json_type do |expected|
  match do |actual|
    match_json_structure_helper(expected, actual)
  end

  def match_json_structure_helper(expected, actual)
    expected.each do |key, value|
      if value.is_a?(Hash)
        return false unless actual.is_a?(Hash) && actual.key?(key)
        return false unless match_json_structure_helper(value, actual[key])
      elsif value == []
        return false unless actual[key] == []
      elsif value.kind_of?(Array)
        return false unless match_json_structure_helper(value.first, actual[key].first)
      else
        return false unless actual.is_a?(Hash) && actual.key?(key) && (actual[key] == value ||actual[key].is_a?(value))
      end
    end
    true
  end
end


