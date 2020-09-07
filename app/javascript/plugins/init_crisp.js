const initCrisp = () => {
    window.$crisp = [];
    window.CRISP_WEBSITE_ID = "ddf26821-c2a7-4929-89da-73f197268d7b";
    const d = document;
    const s = d.createElement("script");
    s.src = "https://client.crisp.chat/l.js";
    s.async = 1;
    d.getElementsByTagName("head")[0].appendChild(s);
  };

export { initCrisp };
