import "bootstrap";

import $ from 'jquery';

// importing flatpickr
import "../plugins/flatpickr"

// importing mapbox
import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import '@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css';
import { initMapbox } from '../plugins/init_mapbox';
// import { initAutocomplete } from '../plugins/init_autocomplete';


initMapbox();

// if (document.querySelector('#meal_address')) {
//   initAutocomplete();
// }
