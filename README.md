# Task Management API

This is a Ruby on Rails-based Task Management API, which allows users to create, manage, and retrieve tasks with JWT-based authentication. It supports CRUD operations, pagination, and integration with PostgreSQL. The API is documented with Swagger UI.

## Features

- **JWT Authentication**: Secure login and token-based authentication.
- **PostgreSQL**: Uses PostgreSQL as the primary database.
- **RESTful API**: Standard CRUD routes for task management.
- **Pagination**: Fetch paginated tasks.
- **Swagger UI**: API documentation with Swagger.
- **CORS enabled**: Supports communication between backend and frontend.

## Prerequisites

- Ruby 3.3.0 or above
- Rails 7.0 or above
- PostgreSQL 12 or above
- Node.js and Yarn
- Postman (for testing APIs)

## Setup

1. Clone the repository:

    ```bash
    git clone https://github.com/ashwinibala/TaskManagementAPI.git
    cd TaskManagementApi
    ```

2. Install dependencies:

    ```bash
    bundle install
    yarn install
    ```

3. Create the database:

    Make sure PostgreSQL is installed and running. Then create and migrate the database.

    ```bash
    rails db:create
    rails db:migrate
    rails db:seed
    ```

4. Setup environment variables:

    Generate Rails credentials for storing the JWT secret key and other sensitive information.

    ```bash
    EDITOR="nano" bin/rails credentials:edit
    ```

    Add the following:

    ```yaml
    jwt_secret: <your-secret-key>
    ```

5. Start the server:

    ```bash
    rails server
    ```

    The API will be available at `http://localhost:8080`.

## JWT Authentication

1. **Login**: Use the `/login` endpoint to authenticate and retrieve a JWT token.
   Example request (using Postman or cURL):

    ```bash
    POST /login
    Content-Type: application/json

    {
      "email": "admin@example.com",
      "password": "password123"
    }
    ```

2. **Protected Routes**: Pass the token in the Authorization header for accessing protected routes.

    ```bash
    Authorization: Bearer <your-jwt-token>
    ```

## API Endpoints

### Task Management Endpoints

- **GET /tasks**: Retrieve all tasks (paginated).
- **POST /tasks**: Create a new task.
- **GET /tasks/:id**: Retrieve a specific task by ID.
- **PUT /tasks/:id**: Update a task by ID.
- **DELETE /tasks/:id**: Delete a task by ID. (soft delete)

### Pagination

Use the `page` and `per_page` parameters to paginate the tasks.

Example:

```bash
GET /tasks?page=1&per_page=10
```

## Docker

```bash
rails secret
```
- environment:
  - SECRET_KEY_BASE=the_generated_key_here
```bash
docker-compose run web bundle install
docker-compose run web rails secret
docker-compose up --build
docker-compose exec web rails db:create db:migrate db:seed
```

## Swagger UI

Once the docker is up, Please hit http://localhost:8080/api-docs/index.html

- Hit the login API. It will have the seeded username and password and provide the token.
- Add the token to the Authorization in the page and hit Authorize.
- All the Task APIs will now be available for use.

# API V1

## Endpoints

### 1. Get All Tasks
- **Endpoint**: `GET /api/v1/tasks`
- **Description**: Retrieves a list of all tasks. Supports filtering by status, searching by title, and pagination.
- **Query Parameters**:
  - `statuses` (optional): Comma-separated list of statuses to filter tasks (e.g., `Backlog`, `Todo`).
  - `search` (optional): Search term to filter tasks by title.
  - `page` (optional): Page number for pagination (default: `1`).
  - `per_page` (optional): Number of tasks per page (default: `10`).
- **Responses**:
  - `200`: Success response with a list of tasks.

### 2. Create a Task
- **Endpoint**: `POST /api/v1/tasks`
- **Description**: Creates a new task.
- **Request Body**:
  - `title` (required): The title of the task.
  - `description` (optional): A description of the task.
  - `status` (optional): The status of the task (default: `Backlog`). Valid options: `Backlog`, `Todo`, `InProgress`, `Completed`, `Cancelled`.
- **Responses**:
  - `201`: Task created successfully.
  - `422`: Invalid request if required fields are missing.

### 3. Get a Specific Task
- **Endpoint**: `GET /api/v1/tasks/{id}`
- **Description**: Retrieves a specific task by its ID.
- **Path Parameter**:
  - `id` (required): The ID of the task to retrieve.
- **Responses**:
  - `200`: Success response with the task details.
  - `404`: Task not found.

### 4. Update a Task
- **Endpoint**: `PUT /api/v1/tasks/{id}`
- **Description**: Updates an existing task.
- **Path Parameter**:
  - `id` (required): The ID of the task to update.
- **Request Body**:
  - `title` (optional): The updated title of the task.
  - `description` (optional): The updated description of the task.
  - `status` (optional): The updated status of the task.
- **Responses**:
  - `200`: Task updated successfully.
  - `404`: Task not found.

### 5. Delete a Task
- **Endpoint**: `DELETE /api/v1/tasks/{id}`
- **Description**: Deletes a specific task by its ID.
- **Path Parameter**:
  - `id` (required): The ID of the task to delete.
- **Responses**:
  - `204`: Task deleted successfully.
  - `404`: Task not found.

### 6. User Login
- **Endpoint**: `POST /api/v1/login`
- **Description**: Authenticates a user and returns a JWT token.
- **Request Body**:
  - `email` (required): The user's email address.
  - `password` (required): The user's password.
- **Responses**:
  - `200`: Login successful with a JWT token.
  - `401`: Invalid credentials.

## Notes
- All endpoints require proper error handling and validation.
- The JWT token obtained from the login endpoint should be included in the `Authorization` header as a Bearer token for protected endpoints.
