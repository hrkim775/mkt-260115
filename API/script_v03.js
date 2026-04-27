// lat = latitude = 위도, lng = langitude = 경도
// 현재 우리가 위치한 곳의 위/경도 값을 구글 맵을 통해서 찾아옴
const lat = 37.4995448;
const lng = 127.0284056;

// 카카오 API를 통해서 받아온 지도 정보를 웹브라우저 내 어디에다가 출력할지를 결정한 변수
var mapContainer = document.getElementById("map"), // 지도를 표시할 div
  mapOption = {
    center: new kakao.maps.LatLng(lat, lng), // 지도의 중심좌표
    level: 3, // 지도의 확대 레벨 (1에 가까우면 줌 인, 10에 가까우면 줌 아웃)
  };

// 지도를 표시할 div와  지도 옵션으로  지도를 생성합니다
var map = new kakao.maps.Map(mapContainer, mapOption);

// 마커 클러스터러를 생성합니다
var clusterer = new kakao.maps.MarkerClusterer({
  map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
  averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
  minLevel: 10, // 클러스터 할 최소 지도 레벨
});

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

var markers = [];

// 파이썬의 for in = 자바스크립트 for문
for (let i = 0; i < positions.length; i++) {
  var marker = new kakao.maps.Marker({
    map: map,
    position: positions[i].latlng,
  });

  markers.push(marker);

  var infowindow = new kakao.maps.InfoWindow({
    content: positions[i].title,
  });

  // 이벤트 함수 : 마우스를 오버했을 때, 실행되는 함수
  function makeOverListener(map, marker, infowindow) {
    return function () {
      infowindow.open(map, marker);
    };
  }

  // 이벤트 함수 : 마우스를 아웃했을 때, 실행되는 함수
  function makeOutListener(infowindow) {
    return function () {
      infowindow.close();
    };
  }

  // addListener : 이벤트가 발생되었을 때, 무언가를 실행시켜주는 매서드
  kakao.maps.event.addListener(
    marker,
    "mouseover",
    makeOverListener(map, marker, infowindow),
  );

  kakao.maps.event.addListener(marker, "mouseout", makeOutListener(infowindow));
}

// 클러스터러에 마커들을 추가합니다
clusterer.addMarkers(markers);
