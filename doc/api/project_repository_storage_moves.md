---
stage: Create
group: Gitaly
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://about.gitlab.com/handbook/engineering/ux/technical-writing/#designated-technical-writers
type: reference
---

# Project repository storage moves API **(CORE ONLY)**

> [Introduced](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/31285) in GitLab 13.0.

Project repositories can be moved between storages. This can be useful when
[migrating to Gitaly Cluster](../administration/gitaly/praefect.md#migrate-existing-repositories-to-gitaly-cluster),
for example.

As project repository storage moves are processed, they transition through different states. Values
of `state` are:

- `initial`
- `scheduled`
- `started`
- `finished`
- `failed`
- `replicated`
- `cleanup_failed`

This API requires you to [authenticate yourself](README.md#authentication) as an administrator.

## Retrieve all project repository storage moves

```plaintext
GET /project_repository_storage_moves
```

By default, `GET` requests return 20 results at a time because the API results
are [paginated](README.md#pagination).

Example request:

```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/project_repository_storage_moves"
```

Example response:

```json
[
  {
    "id": 1,
    "created_at": "2020-05-07T04:27:17.234Z",
    "state": "scheduled",
    "source_storage_name": "default",
    "destination_storage_name": "storage2",
    "project": {
      "id": 1,
      "description": null,
      "name": "project1",
      "name_with_namespace": "John Doe2 / project1",
      "path": "project1",
      "path_with_namespace": "namespace1/project1",
      "created_at": "2020-05-07T04:27:17.016Z"
  }
]
```

## Retrieve all repository storage moves for a project

```plaintext
GET /projects/:project_id/repository_storage_moves
```

By default, `GET` requests return 20 results at a time because the API results
are [paginated](README.md#pagination).

Parameters:

| Attribute | Type | Required | Description |
| --------- | ---- | -------- | ----------- |
| `project_id` | integer | yes | ID of the project |

Example request:

```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects/1/repository_storage_moves"
```

Example response:

```json
[
  {
    "id": 1,
    "created_at": "2020-05-07T04:27:17.234Z",
    "state": "scheduled",
    "source_storage_name": "default",
    "destination_storage_name": "storage2",
    "project": {
      "id": 1,
      "description": null,
      "name": "project1",
      "name_with_namespace": "John Doe2 / project1",
      "path": "project1",
      "path_with_namespace": "namespace1/project1",
      "created_at": "2020-05-07T04:27:17.016Z"
  }
]
```

## Get a single project repository storage move

```plaintext
GET /project_repository_storage_moves/:repository_storage_id
```

Parameters:

| Attribute | Type | Required | Description |
| --------- | ---- | -------- | ----------- |
| `repository_storage_id` | integer | yes | ID of the project repository storage move |

Example request:

```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/project_repository_storage_moves/1"
```

Example response:

```json
{
  "id": 1,
  "created_at": "2020-05-07T04:27:17.234Z",
  "state": "scheduled",
  "source_storage_name": "default",
  "destination_storage_name": "storage2",
  "project": {
    "id": 1,
    "description": null,
    "name": "project1",
    "name_with_namespace": "John Doe2 / project1",
    "path": "project1",
    "path_with_namespace": "namespace1/project1",
    "created_at": "2020-05-07T04:27:17.016Z"
}
```

## Get a single repository storage move for a project

```plaintext
GET /projects/:project_id/repository_storage_moves/:repository_storage_id
```

Parameters:

| Attribute | Type | Required | Description |
| --------- | ---- | -------- | ----------- |
| `project_id` | integer | yes | ID of the project |
| `repository_storage_id` | integer | yes | ID of the project repository storage move |

Example request:

```shell
curl --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects/1/repository_storage_moves/1"
```

Example response:

```json
{
  "id": 1,
  "created_at": "2020-05-07T04:27:17.234Z",
  "state": "scheduled",
  "source_storage_name": "default",
  "destination_storage_name": "storage2",
  "project": {
    "id": 1,
    "description": null,
    "name": "project1",
    "name_with_namespace": "John Doe2 / project1",
    "path": "project1",
    "path_with_namespace": "namespace1/project1",
    "created_at": "2020-05-07T04:27:17.016Z"
}
```

## Schedule a repository storage move for a project

```plaintext
POST /projects/:project_id/repository_storage_moves
```

Parameters:

| Attribute | Type | Required | Description |
| --------- | ---- | -------- | ----------- |
| `project_id` | integer | yes | ID of the project |
| `destination_storage_name` | string | yes | Name of the destination storage shard |

Example request:

```shell
curl --request POST --header "PRIVATE_TOKEN: <your_access_token>" --header "Content-Type: application/json" \
--data '{"destination_storage_name":"storage2"}' "https://gitlab.example.com/api/v4/projects/1/repository_storage_moves"
```

Example response:

```json
{
  "id": 1,
  "created_at": "2020-05-07T04:27:17.234Z",
  "state": "scheduled",
  "source_storage_name": "default",
  "destination_storage_name": "storage2",
  "project": {
    "id": 1,
    "description": null,
    "name": "project1",
    "name_with_namespace": "John Doe2 / project1",
    "path": "project1",
    "path_with_namespace": "namespace1/project1",
    "created_at": "2020-05-07T04:27:17.016Z"
}
```
