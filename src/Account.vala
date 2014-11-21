using Rest;

using TwitterUtils;

 public class Account{
  //コンストラクタ
  public int my_list_id{get;set;}
  public int my_id{get;set;}
  public string my_screen_name{get;set;}
  public string my_profile_image_url{get;set;}
  public string my_time_zone{get;set;}
  public OAuthProxy api_proxy=new OAuthProxy(CONSUMER_KEY,CONSUMER_SECRET,API_URL,false);
  public OAuthProxy stream_proxy=new OAuthProxy(CONSUMER_KEY,CONSUMER_SECRET,STREAM_URL,false);
}
