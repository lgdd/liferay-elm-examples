import './main.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

if (process.env.NODE_ENV === 'development') {
  const login = process.env.ELM_APP_LIFERAY_LOGIN;
  const password = process.env.ELM_APP_LIFERAY_PASSWORD;
  const base64credentials = new Buffer(`${login}:${password}`).toString(
      'base64'
  );
  Elm.Main.init({
    node: document.getElementById('root'),
    flags: {
      env: process.env.NODE_ENV,
      host: 'http://localhost:8080',
      authToken: 'ignored',
      basicAuth: `Basic ${base64credentials}`,
    },
  });
} else {
  Elm.Main.init({
    node: document.getElementById('root'),
    flags: {
      env: process.env.NODE_ENV,
      host: '',
      authToken: window['Liferay'].authToken,
      basicAuth: '',
    },
  });
}

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
