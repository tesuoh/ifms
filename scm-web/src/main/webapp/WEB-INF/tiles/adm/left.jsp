<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<sec:authentication var="menuList" property="principal.sessionVO.menuList"/>

<script type="text/javascript">

	// 현재 선택된 메뉴의 ID를 서버로부터 받음
	var chosenMenuId = '${processedUrl}';

	function findMenuByUpMenuId(menuItems, upId) {
		for (var i = 0; i < menuItems.length; i++) {
			var item = menuItems[i];

			if (item.menu_id == upId) return item;
			if (item.submenu && item.submenu.length > 0) {
				var found = findMenuById(item.submenu, id);
				if (found) return found;
			}
		}
		return null;
	}

	function findMenuByUrl(menuItems, path ) {
		for (var i = 0; i < menuItems.length; i++) {
			var item = menuItems[i];

			if (item.rprs_url_addr && item.rprs_url_addr.startsWith(path)) {
				return item;
			}

			if (item.submenu && item.submenu.length > 0) {
				var found = findMenuByUrl(item.submenu, path);
				if (found) {
					return found;
				}
			}
		}
		return null;
	}

	// 메뉴 아이템이 최상위 메뉴(up_menu_id가 없는)까지 부모를 타고 올라가서 반환
	function findTopLevelByItem(menuItems, menuItem) {
		if (!menuItem.up_menu_id) {
			// up_menu_id가 없다면 현재 아이템이 최상위
			return menuItem;
		}
		var parent = findMenuById(menuItems, menuItem.up_menu_id);
		if (!parent) {
			console.warn("부모를 찾을 수 없습니다. menuItem=", menuItem);
			return menuItem; // 부모가 잘못됐으면 그냥 자기 자신을 반환
		}
		// 부모에도 또 up_menu_id가 있을 수 있으니 재귀
		return findTopLevelByItem(menuItems, parent);
	}

	function findTopLevelMenu(menuItems, chosenUrl) {
		// URL로 해당 메뉴 찾음
		var foundItem = findMenuByUrl(menuItems, chosenUrl);
		if (!foundItem){
			console.log("해당 URL(" + chosenUrl + ")에 해당하는 메뉴를 찾을 수 없습니다.");
			return null;
		}

		return findTopLevelByItem(menuItems, foundItem);
	}

	function buildMenuTree(menuItems, upMenuId) {
		var result = [];
		menuItems.forEach(function (item) {
			if (item.menu_id === upMenuId) {
				result.push(item);
			}
		});

		return result;
	}


	function findMenuById(menuItems, id) {
		for (var i = 0; i < menuItems.length; i++) {
			var item = menuItems[i];

			if (item.menu_id == id) return item;
			if (item.submenu && item.submenu.length > 0) {
				var found = findMenuById(item.submenu, id);
				if (found) return found;
			}
		}
		return null;
	}

	function generateLeftMenu(menuItems, parentElement) {
		menuItems.forEach(function(menuItem) {

			var leftMenuItemElement = $('<li class="nav-item"></li>');
			var link = $('<a href="javascript:;" class="nav-link nav-toggle"></a>');
			link.append('<span class="title">' + menuItem.menu_nm + '</span>');
			leftMenuItemElement.append(link);

			if (menuItem.submenu && menuItem.submenu.length > 0) {
				var leftSubMenu = $('<ul class="sub-menu" style="display: none;"></ul>');
				generateSubMenu(menuItem.submenu, leftSubMenu);
				leftMenuItemElement.append(leftSubMenu);
			} else {
				// 하위 메뉴가 없는 경우, 단일 메뉴로 생성
				link.attr('onclick', "sendForm('" + (menuItem.rprs_url_addr ? menuItem.rprs_url_addr : '#') + "')");
			}
			parentElement.append(leftMenuItemElement);

		});
	}


	$(document).ready(function() {

		if (chosenMenuId === '/adm/main/siteMap.do') {
			console.log("사이트맵 페이지이므로, 메뉴를 생성하지 않습니다.");
			return;
		}

		// 1) chosenMenuId에서 경로 부분만 추출
		var lastSlashIndex = chosenMenuId.lastIndexOf("/");
		var folderPath = chosenMenuId;
		if (lastSlashIndex !== -1) {
			folderPath = chosenMenuId.substring(0, lastSlashIndex + 1);
		}

		// 2) 서버에서 받아온 메뉴 JSON
		var leftActualMenuList = <c:out value="${menuJson}" escapeXml="false"/>;
		var sidebarMenu = $('.page-sidebar-menu');

		try {
			if (leftActualMenuList && leftActualMenuList.length > 0) {
				// 2-1) folderPath를 이용해 최상위 메뉴 찾기
				var topLevelMenu = findTopLevelMenu(leftActualMenuList, folderPath);

				if (topLevelMenu) {
					// 왼쪽 상단 타이틀
					var titleText = topLevelMenu.menu_nm;
					$('.page-sidebar-menu .heading h4.uppercase').text(titleText);

					// 2-2) 최상위 메뉴 ID 기준으로 buildMenuTree
					var selectMenuList = buildMenuTree(leftActualMenuList, topLevelMenu.menu_id);

					if (selectMenuList.length > 0) {
						var firstItem = selectMenuList[0];
						// 최상위 메뉴의 submenu를 그려준다
						var onlySubmenu = firstItem.submenu || [];
						generateLeftMenu(onlySubmenu, sidebarMenu);
					} else {
						console.warn("해당 upMenuId(" + topLevelMenu.menu_id + ")를 가진 항목이 없습니다.");
					}

				}

			} else {
				console.warn('메뉴 데이터가 비어 있습니다.');
			}
		} catch (error) {
			console.error("메뉴 데이터 처리 오류:", error);
		}
	});

</script>

<div id="sidebar" class="page-sidebar-wrapper">
	<div class="page-sidebar" style="min-height: calc(-357px + 100vh); height: 588px;">
		<ul class="page-sidebar-menu" data-keep-expanded="false" data-auto-scroll="true" data-slide-speed="200">
			<li class="heading">
				<h4 class="uppercase" id="title"></h4>
			</li>
			<li class="nav-item">
			</li>
		</ul>
	</div>
</div>

