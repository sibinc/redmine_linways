# Redmine Linways API Documentation

This document provides comprehensive information about the API endpoints available in the Redmine Linways plugin.

## Authentication

All API endpoints require authentication with a valid Redmine API key. You can provide the API key in one of two ways:

1. As an HTTP header: `X-Redmine-API-Key: your-api-key`
2. As a URL parameter: `?key=your-api-key`

To generate an API key in Redmine:
1. Go to "My account" page
2. Click on "Show" next to API access key
3. Click "Generate" if no key exists

## API Versioning

The API is versioned to ensure backward compatibility as new features are added. The current version is v1.

## Available Endpoints

### V1 API Endpoints

#### Get Allowed Issue Status Transitions

Returns the current status and allowed next status transitions for a specific issue.

- **URL**: `/redmine_linways/api/v1/issues/:id/allowed_statuses`
- **Method**: `GET`
- **URL Parameters**:
  - `id` (required): The ID of the issue

- **Success Response**:
  - **Code**: 200 OK
  - **Content**:
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

- **Error Responses**:
  - **Code**: 401 Unauthorized
    - **Content**: `{ "error": "Unauthorized" }`
  - **Code**: 403 Forbidden
    - **Content**: `{ "error": "Access denied" }`
  - **Code**: 404 Not Found
    - **Content**: `{ "error": "Issue not found" }`

- **Sample Call**:
  ```bash
  curl -H "X-Redmine-API-Key: your_api_key" \
       https://your-redmine-instance.com/redmine_linways/api/v1/issues/123/allowed_statuses
  ```

## Legacy Endpoints

For backward compatibility, the following legacy endpoints are maintained:

- `/lin_custom_api/allowed_statuses/:id` -> Maps to `/redmine_linways/api/v1/issues/:id/allowed_statuses`

*Note*: Legacy endpoints may be deprecated in future versions.

## CORS Support

All API endpoints support Cross-Origin Resource Sharing (CORS), allowing them to be called from web applications hosted on different domains.

## Rate Limiting

Currently, there are no rate limits imposed on the API endpoints.

## Additional Resources

For more information about the Redmine API in general, please refer to the [Redmine API documentation](https://www.redmine.org/projects/redmine/wiki/Rest_api).