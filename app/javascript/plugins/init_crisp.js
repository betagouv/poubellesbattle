const initCrisp = () => {
    window.$crisp = [];
    window.CRISP_WEBSITE_ID = "011d8466-c5ac-4f83-bf94-7e5b3405812a";
    const d = document;
    const s = d.createElement("script");
    s.src = "https://client.crisp.chat/l.js";
    s.async = 1;
    d.getElementsByTagName("head")[0].appendChild(s);
  };

export { initCrisp };
