import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const VERSION = '0';
const LAST_SAVE_VERSION = 'last-save-version';
const STATE = 'state';

checkLastVersion()
const app = Main.fullscreen(load());

app.ports.save.subscribe(function(value) {
  console.log("saving");
  save(value);
  console.log("saved");
});

app.ports.load.subscribe(function() {
  console.log("loading");
  checkLastVersion()
  app.ports.loaded.send(load());
  console.log("loaded");
});

registerServiceWorker();

function load() {
  const lastState = window.localStorage.getItem(STATE);
  if (lastState) {
    const state = JSON.parse(lastState);
    return state;
  }
}

function save(props) {
  window.localStorage.setItem(STATE, JSON.stringify(props));
  window.localStorage.setItem(LAST_SAVE_VERSION, VERSION);
}

function checkLastVersion() {
  const lastSaveVersion = window.localStorage.getItem(LAST_SAVE_VERSION);
  if (VERSION !== lastSaveVersion) {
    window.localStorage.clear();
  }
}
