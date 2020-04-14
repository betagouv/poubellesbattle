import mapboxgl from 'mapbox-gl';

import MapboxGeocoder from '@mapbox/mapbox-gl-geocoder';

const initMapbox = () => {
  const mapElement = document.getElementById('map');
  const infoElement = document.getElementById('info');

  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;

    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const markers = JSON.parse(mapElement.dataset.markers);

    const geocoder = new MapboxGeocoder({ accessToken: mapboxgl.accessToken, mapboxgl: mapboxgl });

    markers.forEach((marker) => {

      const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);

      const element = document.createElement('div');
      element.className = 'marker';
      element.style.backgroundImage = `url('${marker.image_url}')`;
      element.style.backgroundSize = 'contain';
      element.style.width = '30px';
      element.style.height = '45px';
      element.style.borderRadius = 0;

      new mapboxgl.Marker(element)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
    });

    fitMapToMarkers(map, markers);
    document.getElementById('geocoder').appendChild(geocoder.onAdd(map));
    if (infoElement) {

      map.on('click', function(e) {
        document.getElementById('info').innerHTML =
        // e.lngLat is the longitude, latitude geographical position of the event

        `<div>longitude ${JSON.stringify(e.lngLat["lng"])}</div>`
        +
        `<div>latitude ${JSON.stringify(e.lngLat["lat"])}</div>`
        +
        `<a rel="nofollow" data-method="post" href="/composteurs/${markers[0]["id"]}/new_manual_latlng?manual_lng=${JSON.stringify(e.lngLat["lng"])}&manual_lat=${JSON.stringify(e.lngLat["lat"])}">Utiliser ces coordonnées</a>`;

        });
    };
    };
};

export { initMapbox };
