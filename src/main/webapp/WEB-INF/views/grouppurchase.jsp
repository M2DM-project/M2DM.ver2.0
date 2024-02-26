<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>All Grouppurchase</title>
</head>
<body>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>All product</title>

    <style>
        body {
            background-color: #F9F1E7;
        }
    </style>

    <style>
        .category_bar {
            background-color: #F9F1E7;
            text-align: center;

            height: 250px;

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

        .top_wrapper {
            padding: 0 80px 50px 80px;
        }
        #gp_list ul {
            list-style: none;
            width: 1032px;

            display: flex;
            flex-flow: wrap;

            margin: auto;
            padding: 0;
        }
        #gp_list li {
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
    <div><h3>공동구매</h3></div>

    <div class="search_bar">
        <input type="text" id="keyword" placeholder="검색어를 입력하세요." />
    </div>

    <button id="category_btn" value="">
        <img src="../../images/category_btn_01.png"><br/>전체
    </button>
    <button id="category_btn" value="FUR">
        <img src="../../images/category_btn_02.png"><br/>가구
    </button>
    <button id="category_btn" value="FAB">
        <img src="../../images/category_btn_03.png"><br/>패브릭
    </button>
    <button id="category_btn" value="AD">
        <img src="../../images/category_btn_04.png"><br/>가전/디지털
    </button>
    <button id="category_btn" value="STO">
        <img src="../../images/category_btn_05.png"><br/>수납/정리
    </button>
    <button id="category_btn" value="DEC">
        <img src="../../images/category_btn_06.png"><br/>소품
    </button>
    <button id="category_btn" value="LIT">
        <img src="../../images/category_btn_07.png"><br/>조명
    </button>
    <button id="category_btn" value="PLA">
        <img src="../../images/category_btn_08.png"><br/>식물
    </button>
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
    </div>

    <div id="gp_list">

    </div>

</div>

<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<script>
    $(document).ready(function() {
        printGroupPurchase();

        $("#keyword").keydown(function(e) {
            if(e.keyCode == 13) {
                let keyword = $(this).val();
                console.log(keyword);

                if (keyword == ""){
                    alert('상품명을 입력해주세요.');
                } else {
                    $.ajax({
                        url: '/gp/search/' + keyword,
                        data: {
                            "keyword" : keyword
                        },
                        success: function(data) {
                            if(data.content.length == 0) {
                                alert('존재하지 않는 상품입니다.');
                            } else {
                                console.log(data);
                                $("#count").html(data.content.length);

                                let grouppurchase_info = "";
                                grouppurchase_info += "<ul>";

                                for(let i = 0; i < data.content.length; i++) {
                                    grouppurchase_info += "<li>"
                                                    + "<a href='/gp/" + data.content[i].id + "/view'>" + "<p>"
                                                    + "<img src='" + data.content[i].imgUrl + "' style='width: 100%; height: 214px;'>" + "<br/>"
                                                    + "<span>" + data.content[i].name + "</span>" + "<br/>"
                                                    + "<span><b>" + data.content[i].price + "원</b></span>"
                                                    + "</a>"
                                                    + "</li>";

                                    if (i % 4 == 3) {
                                        grouppurchase_info += "</ul>";
                                        grouppurchase_info += "<br/><ul>";
                                    }
                                }
                                $("#gp_list").empty();
                                $("#gp_list").html(grouppurchase_info);
                            }
                        }
                    });
                }
            }
        });
    });

    $(document).on('click', '#category_btn', function() {
        let cateCode = $(this).val();
        console.log(cateCode);

        let sortBy = $("#sortSelect option:selected", this).val();

        printGroupPurchase(sortBy, cateCode);
    });

    $("#sortSelect").change(function() {
        let sortBy = $("option:selected", this).val();
        printGroupPurchase(sortBy);
    });

    function printGroupPurchase(sortBy, cateCode) {
        $.ajax ({
            url: '/gp/sort/category',
            data: {
                "sortBy" : sortBy,
                "cateCode" : cateCode
            },
            success: function(data) {
                console.log(data);
                $("#count").html(data.content.length);

                let grouppurchase_info = "";

                grouppurchase_info += "<ul>";
                for(let i = 0; i < data.content.length; i++) {
                    grouppurchase_info += "<li>"
                                        + "<a href='/gp/" + data.content[i].id + "/view'>" + "<p>"
                                        + "<img src='" + data.content[i].imgUrl + "' style='width: 100%; height: 214px;'>" + "<br/>"
                                        + "<span>" + data.content[i].name + "</span>" + "<br/>"
                                        + "<span><b>" + data.content[i].price + "원</b></span>"
                                        + "</a>"
                                        + "</li>";

                    if(i % 4 == 3) {
                        grouppurchase_info += "</ul>";
                        grouppurchase_info += "<br/><ul>";
                    }
                }
                $("#gp_list").empty();
                $("#gp_list").html(grouppurchase_info);

            }
        });
    }


</script>

<%@ include file="includes/footer.jsp" %>



</body>
</html>


</body>
</html>