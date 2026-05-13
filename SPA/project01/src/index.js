import React from "react";
import ReactDOM from "react-dom/client";
import "./index.css";
import App from "./App";
import ReactGA from "react-ga4";
import TagManager from "react-gtm-module";

//GA4
ReactGA.initialize(process.env.REACT_APP_GA_CLIENT_ID);

//GTM
const tagManagerArgs = {
  gtmId: process.env.REACT_APP_GAM_CLIENT_ID,
};

TagManager.initialize(tagManagerArgs);

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(<App />);
