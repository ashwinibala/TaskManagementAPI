# spec/requests/tasks_spec.rb

require 'swagger_helper'

RSpec.describe 'Tasks API', type: :request do
  path '/tasks' do
    get 'Retrieves all tasks' do
      response '200', 'tasks found' do
        run_test!
      end
    end

    post 'Creates a task' do
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string, enum: [ 'Backlog', 'Todo', 'InProgress', 'Completed', 'Cancelled' ], default: 'Backlog' }
        },
        required: [ 'title' ]
      }

      response '201', 'task created' do
        let(:task) { { title: 'Sample Task', description: 'Task description', status: 'Backlog' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:task) { { title: nil } }
        run_test!
      end
    end
  end

  path '/tasks/{id}' do
    get 'Retrieves a task' do
      let(:id) { Task.create(title: 'Sample Task').id }

      response '200', 'task found' do
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
        end
    end

    put 'Updates a task' do
      let(:id) { Task.create(title: 'Sample Task').id }
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          status: { type: :string }
        }
      }

      response '200', 'task updated' do
        let(:task) { { title: 'Updated Task' } }
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    delete 'Deletes a task' do
      let(:id) { Task.create(title: 'Sample Task').id }

      response '204', 'task deleted' do
        run_test!
      end

      response '404', 'task not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
