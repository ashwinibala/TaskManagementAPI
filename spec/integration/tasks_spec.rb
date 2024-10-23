require 'swagger_helper'

RSpec.describe 'Tasks API', type: :request do
  path '/tasks' do
    get 'Retrieves all tasks' do
      tags 'Tasks'
      produces 'application/json'

      response '200', 'tasks found' do
        schema type: :array, items: { type: :object, properties: {
          id: { type: :integer },
          title: { type: :string },
          description: { type: :string },
          status: { type: :string }
        } }

        run_test!
      end
    end
  end
end
