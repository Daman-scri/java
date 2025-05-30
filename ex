// script.js

document.addEventListener("DOMContentLoaded", function () {
  document.querySelector("#specials-tile").addEventListener("click", function () {
    // Load categories and pick a random one
    $ajaxUtils.sendGetRequest("data/categories.json", function (categories) {
      var randomIndex = Math.floor(Math.random() * categories.length);
      var randomCategoryShortName = categories[randomIndex].short_name;

      restaurant.loadMenuItems(randomCategoryShortName);
    });
  });

  // Example for other tiles:
  document.querySelector("#menu-tile").addEventListener("click", function () {
    restaurant.loadMenuCategories();
  });
});

// ajax-utils.js

var $ajaxUtils = (function () {
  function sendGetRequest(requestUrl, responseHandler, isJsonResponse) {
    var request = new XMLHttpRequest();
    request.onreadystatechange = function () {
      if (request.readyState == 4 && request.status == 200) {
        if (isJsonResponse == undefined) {
          isJsonResponse = true;
        }

        if (isJsonResponse) {
          responseHandler(JSON.parse(request.responseText));
        } else {
          responseHandler(request.responseText);
        }
      }
    };
    request.open("GET", requestUrl, true);
    request.send(null);
  }

  return {
    sendGetRequest: sendGetRequest
  };
})();

// restaurant.js

var restaurant = (function () {
  var menuItemsUrl = "data/menu_items/";

  function loadMenuItems(categoryShortName) {
    var url = menuItemsUrl + categoryShortName + ".json";
    $ajaxUtils.sendGetRequest(url, function (menuItems) {
      var html = "<h2>" + menuItems.category.name + "</h2><ul>";
      menuItems.menu_items.forEach(function (item) {
        html += "<li>" + item.name + " - " + item.description + "</li>";
      });
      html += "</ul>";
      document.querySelector("#content-placeholder").innerHTML = html;
    });
  }

  function loadMenuCategories() {
    $ajaxUtils.sendGetRequest("data/categories.json", function (categories) {
      var html = "<h2>Menu Categories</h2><ul>";
      categories.forEach(function (category) {
        html += "<li>" + category.name + "</li>";
      });
      html += "</ul>";
      document.querySelector("#content-placeholder").innerHTML = html;
    });
  }

  return {
    loadMenuItems: loadMenuItems,
    loadMenuCategories: loadMenuCategories
  };
})();

[
  { "short_name": "L", "name": "Lunch" },
  { "short_name": "D", "name": "Dinner" },
  { "short_name": "S", "name": "Sushi" },
  { "short_name": "V", "name": "Vegetarian" }
]
{
  "category": { "short_name": "L", "name": "Lunch" },
  "menu_items": [
    { "name": "Grilled Cheese", "description": "Cheesy and delicious" },
    { "name": "BLT", "description": "Bacon, lettuce, and tomato" }
  ]
}
