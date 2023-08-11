enum API {
  // user
  register,
  // map
  postLocationAndBattery,
  getLocationAndBattery,
}

Map<API, String> apiMap = {
  // user
  API.register: '/register',
  // map
  API.postLocationAndBattery: '/api/v1/users/location-and-battery',
  API.getLocationAndBattery: '/api/v1/users/all-user-location-and-battery',
};
