# DuckHTTP

**DuckHTTP** is a minimal HTTP proxy server for [DuckDB](https://duckdb.org) in 50 lines of YAML.

## Getting Started

### 1. Build and start the **DuckHTTP** service
```shell
docker compose up --build
```

### 2a. Send query via browser

```http
http://localhost:3000/"SELECT 'world' AS hello;"
```
Try `Firefox` as it is very lenient on URL inputs and renders JSON responses nicely.

### 2b. Send query via terminal

```shell
wget -qO- http://localhost:3000/"SELECT 'world' AS hello;"
```
```shell
curl "http://localhost:3000/%22SELECT%20%27world%27%20AS%20hello%3B%22"
```

## Details

* **Dependencies:** [`docker compose`](https://docs.docker.com/compose/)
* **Container:** The build process downloads DuckDB and the server.
* **HTTP Server:** [`bento`](https://github.com/warpstreamlabs/bento) (but compatible to `connect`/`benthos`)
* **DuckDB Client API:** The [CLI](https://duckdb.org/docs/api/cli/overview) is used via the [`subprocess`](https://docs.redpanda.com/redpanda-connect/components/processors/subprocess/) processor.
* **Default Port:** `3000`
* **Endpoint:** The query is placed in the URL right after the domain and wrapped in double quotes of a HTTP `GET` request.
* **Responses:** A response in JSON and consists on the top level out of an array with each element corresponding to a SQL statement that has a return value,
  SQL statements without a return value will not appear: 
  * `SELECT 1;` returns `[[{"1":1}]]`
  * `ANALYZE; SELECT 1;` returns `[[{"1":1}]]`
  * `SELECT 1; SELECT 2;` returns `[[{"1":1}],[{"2":2}]]`

## Known Issues

* Some HTTP Clients may need to URL-encode the query.
* Earlier `compose` versions cannot handle inline Dockerfiles.
  In this case copy the content of the `dockerfile_inline` property into a file names `Dockerfile` and make double dollars into single dollar.
* `bento` is used instead of `benthos` as it provides pre-build binaries.
* After an error in a query the subsequent query can contain results from the previous query.
