# spec/controllers/tasks_controller_spec.rb

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:task) { create(:task, created_by: user.name) }

  before do
    request.env['HTTP_AUTHORIZATION'] = "Bearer #{user.token}"
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    context 'when the task exists' do
      it 'returns a success response' do
        get :show, params: { id: task.id }
        expect(response).to have_http_status(:success)
      end

      it 'returns the task' do
        get :show, params: { id: task.id }
        expect(JSON.parse(response.body)['id']).to eq(task.id)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found response' do
        get :show, params: { id: 9999 }  # Assuming this ID does not exist
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { { task: { title: 'New Task', description: 'Task description', status: 'active' } } }

      it 'creates a new Task' do
        expect {
          post :create, params: valid_attributes
        }.to change(Task, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { task: { title: '', description: '' } } }

      it 'does not create a new Task' do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Task, :count)
      end

      it 'returns an unprocessable entity response' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { title: 'Updated Task Title' } }

      it 'updates the task' do
        put :update, params: { id: task.id, task: new_attributes }
        task.reload
        expect(task.title).to eq('Updated Task Title')
      end

      it 'returns a success response' do
        put :update, params: { id: task.id, task: new_attributes }
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { title: '' } }  # Title can't be blank

      it 'does not update the task' do
        put :update, params: { id: task.id, task: invalid_attributes }
        task.reload
        expect(task.title).not_to eq('')
      end

      it 'returns an unprocessable entity response' do
        put :update, params: { id: task.id, task: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found response' do
        put :update, params: { id: 9999, task: { title: 'New Title' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the task exists' do
      it 'deletes the task' do
        expect {
          delete :destroy, params: { id: task.id }
        }.to change(Task, :count).by(-1)
      end

      it 'returns a success response' do
        delete :destroy, params: { id: task.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the task does not exist' do
      it 'returns a not found response' do
        delete :destroy, params: { id: 9999 }  # Assuming this ID does not exist
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
