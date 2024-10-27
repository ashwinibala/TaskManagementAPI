# spec/requests/api/v1/tasks_spec.rb

require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let(:user) { create(:user) }
  let(:task) { create(:task, created_by: user.name) }

  before do
    # Set up authorization if necessary
    allow_any_instance_of(Api::V1::TasksController).to receive(:current_user).and_return(user)
  end

  describe 'GET /api/v1/tasks' do
    it 'returns a success response' do
      get '/api/v1/tasks'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    context 'when the task exists' do
      it 'returns a success response' do
        get "/api/v1/tasks/#{task.id}"
        expect(response).to have_http_status(:success)
      end

      it 'returns the task' do
        get "/api/v1/tasks/#{task.id}"
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['id']).to eq(task.id)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found response' do
        get '/api/v1/tasks/9999'  # Assuming this ID does not exist
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /api/v1/tasks' do
    context 'with valid params' do
      let(:valid_attributes) { { task: { title: 'New Task', description: 'Task description', status: 'active' } } }

      it 'creates a new Task' do
        expect {
          post '/api/v1/tasks', params: valid_attributes
        }.to change(Task, :count).by(1)
      end

      it 'returns a created response' do
        post '/api/v1/tasks', params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { task: { title: '', description: '' } } }

      it 'does not create a new Task' do
        expect {
          post '/api/v1/tasks', params: invalid_attributes
        }.not_to change(Task, :count)
      end

      it 'returns an unprocessable entity response' do
        post '/api/v1/tasks', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/tasks/:id' do
    context 'with valid params' do
      let(:new_attributes) { { task: { title: 'Updated Task Title' } } }

      it 'updates the task' do
        put "/api/v1/tasks/#{task.id}", params: new_attributes
        task.reload
        expect(task.title).to eq('Updated Task Title')
      end

      it 'returns a success response' do
        put "/api/v1/tasks/#{task.id}", params: new_attributes
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { task: { title: '' } } }

      it 'does not update the task' do
        put "/api/v1/tasks/#{task.id}", params: invalid_attributes
        task.reload
        expect(task.title).not_to eq('')
      end

      it 'returns an unprocessable entity response' do
        put "/api/v1/tasks/#{task.id}", params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found response' do
        put '/api/v1/tasks/9999', params: { task: { title: 'New Title' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    context 'when the task exists' do
      it 'deletes the task' do
        expect {
          delete "/api/v1/tasks/#{task.id}"
        }.to change(Task, :count).by(-1)
      end

      it 'returns a success response' do
        delete "/api/v1/tasks/#{task.id}"
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found response' do
        delete '/api/v1/tasks/9999'  # Assuming this ID does not exist
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
