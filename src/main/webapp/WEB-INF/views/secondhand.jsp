<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>All product</title>
    <style>
        body {
            background-color: #F9F1E7;
        }
        .category_bar {
            background-color: #F9F1E7;
            text-align: center;
            height: 280px;
            padding: 10px 50px 10px 50px;
        }
        #category_btn {
            background-color: white;
            width: 90px;
            height: 90px;
            border: none;
            border-radius: 50%;
            margin: 20px;
        }
        .category_bar img {
            width: 50px;
            height: 50px;
        }
        .search_bar input {
            width: 50%;
            height: 40px;
            border: none;
            border-radius: 25px;
            padding-left: 15px;
            margin-top: 10px;
            margin-bottom: 10px;
        }
        .content_wrapper {
            background-color: #FFFFFF;
            padding-top: 30px;
            padding-left: 150px;
            padding-right: 150px;
        }
        #addSecondhand {
            background-color: #FF7500;
            color: white;
            font-size: 13px;
            text-align: center;
            width: 80px;
            height: 25px;
            border: none;
            border-radius: 10px;
        }
        .top_wrapper {
            padding: 0 80px 50px 80px;
        }
        #secondhand_list ul {
            list-style: none;
            width: 1032px;
            display: flex;
            flex-flow: wrap;
            margin: auto;
            padding: 0;
        }
        #secondhand_list li {
            list-style: none;
            text-align: right;
            width: 214px;
            padding: 20px;
            margin: 1px;
        }
        a:link, a:visited {
            text-decoration: none;
            color: black;
        }
    </style>
</head>

<body>

    <%@ include file="includes/header.jsp" %>

    <div class="category_bar">
        <div><h3>중고거래</h3></div>
        <div class="search_bar">
            <input type="text" id="keyword" placeholder="검색어를 입력하세요." />
        </div>
        <table style="text-align: center; font-size: 14px; margin: auto;">
            <tr>
                <td>
                    <button id="category_btn" value="">
                        <img src="../../images/category/category_btn_01.png">
                    </button>
                    <br/>전체
                </td>
                <td>
                    <button id="category_btn" value="FUR">
                        <img src="../../images/category/category_btn_02.png">
                    </button>
                    <br/>가구
                </td>
                <td>
                    <button id="category_btn" value="FAB">
                        <img src="../../images/category/category_btn_03.png">
                    </button>
                    <br/>패브릭
                </td>
                <td>
                    <button id="category_btn" value="AD">
                        <img src="../../images/category/category_btn_04.png">
                    </button>
                    <br/>가전/디지털
                </td>
                <td>
                    <button id="category_btn" value="STO">
                        <img src="../../images/category/category_btn_05.png">
                    </button>
                    <br/>수납/정리
                </td>
                <td>
                    <button id="category_btn" value="DEC">
                        <img src="../../images/category/category_btn_06.png">
                    </button>
                    <br/>소품
                </td>
                <td>
                    <button id="category_btn" value="LIT">
                        <img src="../../images/category/category_btn_07.png">
                    </button>
                    <br/>조명
                </td>
                <td>
                    <button id="category_btn" value="PLA">
                        <img src="../../images/category/category_btn_08.png">
                    </button>
                    <br/>식물
                </td>
            </tr>
        </table>
    </div>

    <div class="content_wrapper">
        <div class="top_wrapper">
            <div class="count" style="float: left;"><b>총<span id="count" style="padding-left: 8px; padding-right: 3px;">product_count</span>개</b></div>
            <div class="sort" style="float: right;">
                <div class="sort_type">
                    <select id="sortSelect">
                        <option value="newest">최신순</option>
                        <option value="highprice">높은 가격순</option>
                        <option value="lowprice">낮은 가격순</option>
                    </select>
                </div>
            </div>
            <button id="addSecondhand" onclick="location.href='/secondhand/add/view'" style="float: right; margin-right: 15px;">상품 등록</button>
        </div>
        <div id="secondhand_list"></div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script>

        $(document).ready(function() {
            printSecondHand();

            $("#keyword").keydown(function(e) {
                if(e.keyCode == 13) {
                    let keyword = $(this).val();

                    if (keyword == ""){
                        alert('상품명을 입력해주세요.');
                    } else {
                        $.ajax({
                            url: '/secondhand/search/' + keyword,
                            data: {
                                "keyword" : keyword
                            },
                            success: function(data) {
                                if(data.content.length == 0) {
                                    alert('존재하지 않는 상품입니다.');
                                } else {
                                    $("#count").html(data.content.length);

                                    let secondhand_info = "";
                                    secondhand_info += "<ul>";
                                    for(let i = 0; i < data.content.length; i++) {
                                        secondhand_info += "<li>"
                                                        + "<a href='/secondhand/" + data.content[i].id + "/view'>" + "<p>"
                                                        if (data.content[i].state == 'y') {
                                                            secondhand_info += "<img src='../../images/secondhand/" + data.content[i].imgUrl + "' style='width: 100%; height: 214px; filter: grayscale(100%);'>" + "<br/>";
                                                        } else {
                                                            secondhand_info += "<img src='../../images/secondhand/" + data.content[i].imgUrl + "' style='width: 100%; height: 214px;'>" + "<br/>";
                                                        }
                                        secondhand_info += "<span>" + data.content[i].name + "</span>" + "<br/>"
                                                            + "<span><b>" + data.content[i].price + "원</b></span>"
                                                            + "</a>"
                                                        + "</li>";

                                        if (i % 4 == 3) {
                                            product_info += "</ul>";
                                            product_info += "<br/><ul>";
                                        }
                                    }
                                    $("#secondhand_list").empty();
                                    $("#secondhand_list").html(secondhand_info);
                                }
                            }
                        })
                    }
                }
            });
        });

        let cateCode = "";
        $(document).on('click', '#category_btn', function() {
            cateCode = $(this).val();
            let sortBy = $("#sortSelect option:selected", this).val();

            printSecondHand(sortBy, cateCode);
        });

        $("#sortSelect").change(function() {
            let sortBy = $("option:selected", this).val();
            printSecondHand(sortBy, cateCode);
        });

        function printSecondHand(sortBy, cateCode) {
            $.ajax ({
                url: '/secondhand/sort/category',
                data: {
                    "sortBy" : sortBy,
                    "cateCode" : cateCode
                },
                success: function(data) {
                    $("#count").html(data.content.length);

                    let secondhand_info = "";
                    secondhand_info += "<ul>";
                    for(let i = 0; i < data.content.length; i++) {
                        secondhand_info += "<li>"
                                            + "<div style='text-align: left;'>" + printStatus(data.content[i].state) + "</div>"
                                            + "<a href='/secondhand/" + data.content[i].id + "/view'>" + "<p>"
                                            if (data.content[i].state == 'y') {
                                                secondhand_info += "<img src='../../images/secondhand/" + data.content[i].imgUrl + "' style='width: 100%; height: 214px; filter: grayscale(100%);'>" + "<br/>";
                                            } else {
                                                secondhand_info += "<img src='../../images/secondhand/" + data.content[i].imgUrl + "' style='width: 100%; height: 214px;'>" + "<br/>";
                                            }
                        secondhand_info += "<span>" + data.content[i].name + "</span>" + "<br/>"
                                            + "<span><b>" + data.content[i].price + "원</b></span>"
                                            + "</a>"
                                        + "</li>";
                        if(i % 4 == 3) {
                            secondhand_info += "</ul>";
                            secondhand_info += "<br/><ul>";
                        }
                    }

                    $("#secondhand_list").empty();
                    $("#secondhand_list").html(secondhand_info);
                }
            })
        }

        function printStatus(state) {
            let status = "";
            if (state == 'y') {
                status += "<span style='background-color: #616161; color: #FFFFFF; font-size: 14px; padding: 3px 7px; margin-bottom: 5px; border-radius: 7px;'>판매 완료</span>";
            } else if (state == 'n') {
                status += "<span style='background-color: #84D444; color: #FFFFFF; font-size: 14px; padding: 3px 7px; margin-bottom: 5px; border-radius: 7px;'>판매 중</span>";
            }
            return status;
        }

    </script>

    <%@ include file="includes/footer.jsp" %>

</body>
</html>
