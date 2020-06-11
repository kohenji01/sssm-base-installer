{strip}
  {*
  プログレスバー使用方法

  下記の件のコード参照のこと
  バー自体のidを設定し
  ボタンの
  　data-gpbarid : バーのID
  　data-api : 実行するAPI
  を設定し、classに「pgbar_start」を与えてください。

    <div class="progress">
        <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%" id="pgbar_1"></div>
    </div>
    <button class="pgbar_start" id="pgbar_start_1" data-pgbarid="pgbar_1" data-api="{$smarty.server.SCRIPT_NAME}/Api/Sssm.Install.Models.DBInit/progressTestExec/background?">Start</button>
  *}
<script>
{literal}
$('.pgbar_start').click(function(event) {

  // HTMLでの送信をキャンセル
  event.preventDefault();

  const data = $(this).data();
  const progress_bar_id="#"+data.pgbarid;
  const progress_bar_btn_id="#"+$(this).attr('id');
  const api_url = data.api;

  $(progress_bar_btn_id).attr('disabled',true);
  $(progress_bar_id).attr('aria-valuenow','0').css('width', '0%').html('');
  $(progress_bar_id).addClass("progress-bar-animated");

  // 送信
  $.ajax({
    //Creat progress bar instance
    url: "{/literal}{$smarty.server.SCRIPT_NAME}/Api/Sssm.Base.API.ProgressBar/startProgress{literal}",
    type: "GET",
    dataType: "json",

    // 通信成功時の処理
    success: function(pid, textStatus, xhr) {
      if( pid !== 'false' ){
        $.ajax({
          url: api_url+"&pid="+pid,
          type: 'GET'
        });

        let myInterval = setInterval(function () {
          $.ajax({
            type: "GET",
            url: "{/literal}{$smarty.server.SCRIPT_NAME}/Api/Sssm.Base.API.ProgressBar/getProgress?pid={literal}" + pid,
            dataType: "json",
            success: function (result, textStatus, xhr) {
              $(progress_bar_id).attr('aria-valuenow', result.percentage).css('width', result.percentage + '%').html(result.percentage + '%');
              if (result.percentage >= 100) {
                clearInterval(myInterval);
                $(progress_bar_id).removeClass("progress-bar-animated");
                $(progress_bar_btn_id).attr('disabled', false);
              }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
              alert('Error : ' + errorThrown);
            }
          });
        }, 1000);
      }
    },

    error: function(xhr, textStatus, error) {
      alert('Communication error.');
    }
  });
});
{/literal}
</script>
{/strip}