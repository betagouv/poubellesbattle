import "bootstrap";

import $ from 'jquery';

// importing flatpickr
import "../plugins/flatpickr"

// importing mapbox
import 'mapbox-gl/src/css/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import '@mapbox/mapbox-gl-geocoder/lib/mapbox-gl-geocoder.css';
import { initMapbox } from '../plugins/init_mapbox';
// import { initAutocomplete } from '../plugins/init_autocomplete';


initMapbox();

$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

// if (document.querySelector('#meal_address')) {
//   initAutocomplete();
// }

import "controllers"
