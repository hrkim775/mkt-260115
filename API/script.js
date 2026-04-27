const url =
  "https://apis.data.go.kr/B551011/GoCamping/basedList?serviceKey=32852873e25d85bf199a671eb5c37d91ec4ac0ae04f9770f5a1bc2a5a249ee87&numOfRows=4000&pageNo=1&MobileOS=ETC&MobileApp=gocamping&_type=json";

fetch(url)
  .then((response) => response.json())
  .then((result) => {
    const data = result.response.body.items.item;

    const showPosition = (position) => {
      const latitude = position.coords.latitude;
      const longitude = position.coords.longitude;

      var container = document.getElementById("map");

      var options = {
        center: new kakao.maps.LatLng(latitude, longitude),
        level: 3,
      };

      var map = new kakao.maps.Map(container, options);

      var clusterer = new kakao.maps.MarkerClusterer({
        map: map,
        averageCenter: true,
        minLevel: 10,
      });

      var markers = [];

      for (let i = 0; i < data.length; i++) {
        var marker = new kakao.maps.Marker({
          map: map,
          position: new kakao.maps.LatLng(data[i].mapY, data[i].mapX),
        });

        markers.push(marker);

        var infowindow = new kakao.maps.InfoWindow({
          content: data[i].facltNm,
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

        kakao.maps.event.addListener(
          marker,
          "mouseout",
          makeOutListener(infowindow),
        );
      }

      clusterer.addMarkers(markers);
    };

    const errorPosition = (err) => {
      alert(err.message);
    };

    window.navigator.geolocation.getCurrentPosition(
      showPosition,
      errorPosition,
    );
  });
