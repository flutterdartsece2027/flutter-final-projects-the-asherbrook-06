const String GOOGLE_MAPS_API = "AIzaSyCGoAdJ9FBOIKkuit2Nf-bsk90eftHyIWw";

const List MAP_STYLE_LIGHT = [
  {
    "elementType": "labels.icon",
    "stylers": [
      {"visibility": "off"},
    ],
  },
];
const List MAP_STYLE_DARK = [
  {
    "elementType": "geometry",
    "stylers": [
      {"color": "#212121"},
    ],
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {"visibility": "off"},
    ],
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {"color": "#757575"},
    ],
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {"color": "#212121"},
    ],
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {"color": "#373737"},
    ],
  },
];
