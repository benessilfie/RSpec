# frozen_string_literal: true

require_relative '../../../app/api'

module ExpenseTracker
  RSpec.describe API do
    describe 'POST/expenses' do
      context 'when the expense is succesfully recorded' do
        it 'returns the expense id'
        it 'returns with a 200 (OK)'
      end

      context 'when the expenses fails validation' do
        it 'returns an error message'
        it 'returns with a 422 (Unprocessable entity)'
      end
    end
  end
end
