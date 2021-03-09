# Liferay Elm App Example: Fetch Virtual Instances

This is an example fetching the list of virtual instances using Liferay Headless APIs. In dev mode, basic authentication is used and in production mode (deployed on Liferay)

## How to use

Quickstart:

```shell
docker-compose up -d --build
```

It's going to start Liferay Portal 7.3.5 GA6 with the current Elm App pre-installed. So then you can:

- Go to http://localhost:8080
- Login with default admin (`test@liferay.com` | `test`)
- Edit Home Page
- Drag'n'drop `fetch-virtual-instances` onto the page
- Publish

To start dev mode:

```shell
yarn start
```

Then you can go to `http://localhost:3000` and experience your application in standalone mode. Make sure that Liferay has started in the background, so the APIs are available. Note that this Liferay Docker container brings Portal CORS configuration to make sure this app in dev mode can send `GET` methods to `/o/headless-portal-instances/v1.0/portal-instances` from `http://localhost:3000`.

## Liferay Elm App

This project was generated with [Liferay Elm](https://github.com/lgdd/generator-liferay-elm) and bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).

More information about `Liferay Elm` [here](https://github.com/lgdd/generator-liferay-elm#readme).

More information about `Create Elm App` guide [here](https://github.com/halfzebra/create-elm-app/blob/master/template/README.md).
