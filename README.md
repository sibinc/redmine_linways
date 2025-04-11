# Redmine Linways API Plugin

A custom Redmine API extension plugin that provides additional API endpoints for integration with other systems.

## Features

* **Issue Status API**: Get allowed next status transitions for an issue
* Structured for easy addition of new API endpoints
* Versioned API design
* Backward compatibility with older endpoint URLs

## Installation

1. Clone this repository into your Redmine plugins directory:
   ```
   cd /path/to/redmine/plugins/
   git clone https://your-repository-url/redmine_linways.git
   ```

2. Restart your Redmine application:
   ```
   touch /path/to/redmine/tmp/restart.txt
   ```

## API Documentation

### Authentication

All API requests require authentication using a Redmine API key. The API key can be provided in one of two ways:
- As a header: `X-Redmine-API-Key: your-api-key`
- As a URL parameter: `?key=your-api-key`

### Available Endpoints

#### Issue Status Transitions

Get a list of allowed status transitions for an issue.

* **URL**: `/redmine_linways/api/v1/issues/:id/allowed_statuses`
* **Method**: `GET`
* **URL Params**: 
  * Required: `id=[integer]` (Issue ID)
* **Response Format**:
  ```json
  {
    "issue_id": 123,
    "current_status": {
      "id": 1,
      "name": "New"
    },
    "allowed_next_statuses": [
      {
        "id": 2,
        "name": "In Progress"
      },
      {
        "id": 3,
        "name": "Resolved"
      }
    ]
  }
  ```

* **Error Responses**:
  * 401 Unauthorized: Invalid or missing API key
  * 403 Forbidden: User doesn't have permission to view the issue
  * 404 Not Found: Issue doesn't exist

**Legacy URL**: `/lin_custom_api/allowed_statuses/:id` (Supported for backward compatibility)

## Development

### Adding New Endpoints

To add new API endpoints:

1. Create new controllers in `app/controllers/redmine_linways/api/v1/` or create a new version namespace
2. Add routes in `config/routes.rb`
3. Update documentation

### Running Tests

```
cd /path/to/redmine
bundle exec rake redmine:plugins:test NAME=redmine_linways
```

## License

This plugin is licensed under the MIT License.

## Authors

* Sibin C - Initial work