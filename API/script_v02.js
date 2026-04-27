const lat = 37.4995448;
const lng = 127.0284056;

var mapContainer = document.getElementById("map"), // 지도를 표시할 div
  mapOption = {
    center: new kakao.maps.LatLng(lat, lng), // 지도의 중심좌표
    level: 3, // 지도의 확대 레벨
  };

// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
var map = new kakao.maps.Map(mapContainer, mapOption);

// 마커를 표시할 위치와 title 객체 배열입니다
var positions = [
  {
    title: '<div style="padding:5px;font-size:0.9rem;">메가스터디IT</div>',
    latlng: new kakao.maps.LatLng(lat, lng),
  },
  {
    title: '<div style="padding:5px;font-size:0.9rem;">그린아카데미</div>',
    latlng: new kakao.maps.LatLng(37.5001635, 127.0290434),
  },
  {
    title: '<div style="padding:5px;font-size:0.9rem;">SBS아카데미</div>',
    latlng: new kakao.maps.LatLng(37.4979437, 127.0265374),
  },
  {
    title: '<div style="padding:5px;font-size:0.9rem;">이젠아카데미</div>',
    latlng: new kakao.maps.LatLng(37.5012617, 127.0251333),
  },
];

for (var i = 0; i < positions.length; i++) {
  // 마커를 생성합니다
  var marker = new kakao.maps.Marker({
    map: map, // 마커를 표시할 지도
    position: positions[i].latlng, // 마커를 표시할 위치
    title: positions[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
  });

  var infowindow = new kakao.maps.infowindow({
    content: positions[i].title,
  });

  function makeOverListener(map, marker, infowindow) {
    return function () {
      infowindow.open(map, marker);
    };
  }

  function makeOutListener(infowindow) {
    return function () {
      infowindow.close();
    };
  }

  kakao.maps.event.addListener(
    marker,
    "mouseover",
    makeOverListener(map, marker, infowindow),
  );

  kakao.maps.event.addListener(marker, "mouseout", makeOutListener(infowindow));
}
