<html>
<head>
<title>Print Calendar</title>
<style type="text/css">
body {
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 90%;
}
</style>
<body>

<a class="button" href="#" id="print">#calendar.Print#</a>
<a class="button" href="#" id="close">#calendar.Close_Window#</a>
<br><br>

<if @items:rowcount@ gt 0>
  <multiple name="items">
  <div style="border: 1px solid #ccc;">
  <div style="background-color: #ddd; padding: 5px;">
  <span style="color: maroon; font-weight: bold;">@items.event_name@</span><br>
  <span style="font-weight: bold;">#calendar.Date#</span> @items.start_date@ &nbsp;&nbsp;&nbsp; <if @items.start_time@ ne @items.end_time@>@items.start_time@ &ndash; @items.end_time@</if>
  <div style="font-size:85%; color: #666; border-bottom: 1px solid #666; border-top: 1px solid #666; margin-top: 3px; margin-bottom: 3px; padding-bottom: 2px; padding-top: 2px;">
  @items.calendar_name@
  </div>
  </div>
  <div style="padding: 5px;">
  @items.description@
  </div>
  </div>
  <br>
  </multiple>
</if>
</body>
</html>
<script type="text/javascript" <if @::__csp_nonce@ not nil> nonce="@::__csp_nonce;literal@"</if>>
    document.querySelector('#print').addEventListener('click', function (e) {
        window.print();
    });
    document.querySelector('#close').addEventListener('click', function (e) {
        window.close();
    });
</script>
