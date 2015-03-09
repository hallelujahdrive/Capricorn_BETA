using Json;

namespace TwitterUtil{
  public class ParsedJsonObj{
    //インスタンス
    public string name;
    public string screen_name;
    public string profile_image_url;
    public bool account_is_protected;
    
    public string text;
    public string source_label;
    public string source_url;
    public string id_str;
    
    public media[]? media_array=null;
    public urls[]? urls_array=null;
    
    public string rt_name;
    public string rt_screen_name;
    public string rt_profile_image_url;
    
    public string? in_reply_to_status_id;
    
    public bool retweeted;
    public bool favorited;
    
    public bool is_tweet=false;
    public bool is_reply=false;
    public bool is_retweet=false;
    public bool is_mine=false;
    public bool is_delete=false;
    
    public DateTime created_at;
    public ParsedJsonObj(string json_str,string? my_screen_name){
      //json_obj
      Json.Parser json_parser=new Json.Parser();
      try{
        json_parser.load_from_data(json_str);
        Json.Node json_node=json_parser.get_root();
        if(json_node!=null){
          Json.Object json_obj=json_node.get_object();
          Json.Object json_main_obj;
          
          //jsonを解析
          //retweetの場合,各情報を取得
          if(json_obj.has_member("retweeted_status")){
            is_retweet=true;
            json_main_obj=json_obj.get_object_member("retweeted_status");
            foreach(string member in json_obj.get_members()){
              switch(member){
                case "user":
                Json.Object rt_user_obj=json_obj.get_object_member("user");
                foreach(string user_member in rt_user_obj.get_members()){
                  switch(user_member){
                    case "name":rt_name=parse_name(rt_user_obj.get_string_member("name"));
                    break;
                    case "screen_name":
                    if((rt_screen_name=rt_user_obj.get_string_member("screen_name"))==my_screen_name){
                      retweeted=true;
                    }
                    break;
                    case "profile_image_url":rt_profile_image_url=rt_user_obj.get_string_member("profile_image_url");
                    break;
                  }
                }
                break;
              }
            }
          }else if(json_obj.has_member("delete")){
            //deleteの解析.json_main_objはstatusから取得
            is_delete=true;
            json_main_obj=(json_obj.get_object_member("delete")).get_object_member("status");
          }else{
            //retweetedではなかった場合,json_objそのものがjson_main_objになる
            json_main_obj=json_obj;
          }
          if(json_main_obj.has_member("id_str")){
            //jsonの解析
            foreach(string member in json_main_obj.get_members()){
              switch(member){
                case "created_at":parse_created_at(json_main_obj.get_string_member(member));
                break;
                case "favorited":favorited=json_main_obj.get_boolean_member(member);
                break;
                case "id_str":id_str=json_main_obj.get_string_member(member);
                break;
                case "in_reply_to_status_id_str":in_reply_to_status_id=json_main_obj.get_string_member(member);
                break;
                case "retweeted":retweeted=json_main_obj.get_boolean_member(member);
                break;
                case "source":parse_source(json_main_obj.get_string_member(member));
                break;
                case "entities":
                case "extended_entities":
                //entitiesの解析
                Json.Object entities_obj=json_main_obj.get_object_member(member);
                foreach(string entities_member in entities_obj.get_members()){
                  switch(entities_member){
                    case "media":parse_media(entities_obj.get_array_member(entities_member));
                    break;
                    case "urls":parse_urls(entities_obj.get_array_member(entities_member));
                    break;
                  }
                }
                break;
                case "text":
                text=json_main_obj.get_string_member(member);
                is_tweet=true;
                if(my_screen_name!=null){
                  is_reply=text.contains(my_screen_name);
                }
                //debug
                if(text.contains("#debug")){
                  print("%s\n",json_str);
                }
                break;
                case "user":
                //userの解析
                Json.Object user_obj=json_main_obj.get_object_member(member);
                foreach(string user_member in user_obj.get_members()){
                  switch(user_member){
                    case "name":name=parse_name(user_obj.get_string_member(user_member));
                    break;
                    case "screen_name":
                    screen_name=user_obj.get_string_member(user_member);
                    if(my_screen_name==screen_name){
                      is_mine=true;
                    }
                    break;
                    case "profile_image_url":profile_image_url=user_obj.get_string_member(user_member);
                    break;
                    case "protected":account_is_protected=user_obj.get_boolean_member(user_member);
                    break;
                  }
                }
                break;
              }
            }
          }
        }
      }catch(Error e){
        print("%s\n",e.message);
      }
    }
    //created_atのparse
    private void parse_created_at(string get_created_at){
      try{  //セイキヒョウゲンカッコバクショウで投稿日時を解析
        var created_at_regex_replace=new Regex("(:)");
        string created_at_regex=created_at_regex_replace.replace(get_created_at,-1,0," ");
        string[] created_at_split=created_at_regex.split(" ");
        int month=month_str_to_num(created_at_split[1]);
        int day=int.parse(created_at_split[2]);
        int hour=int.parse(created_at_split[3]);
        int minute=int.parse(created_at_split[4]);
        int second=int.parse(created_at_split[5]);
        int year=int.parse(created_at_split[7]);
        created_at=new DateTime.utc(year,month,day,hour,minute,second);
      }catch(Error e){
        print("%s\n",e.message);
      }
    }
    //nameの&の置換(やらないとmark upでコケる
    private string parse_name(string get_name){
      string name_regex=null;
      try{  //セイキヒョウゲンカッコバクショウでクライアント名とURLを解析
        var name_regex_replace=new Regex("(&)");
        name_regex=name_regex_replace.replace(get_name,-1,0,"&amp;");
      }catch(Error e){
        print("%s\n",e.message);
      }
      return name_regex;
    }
    private void parse_source(string get_source){
      string[] source_split={"",""};
      //セイキヒョウゲンカッコバクショウでクライアント名とURLを解析
      try{
        var source_regex_replace=new Regex("(<a href=|rel=\"nofollow\"|\"|</a>)");
        string source_regex=source_regex_replace.replace(get_source,-1,0,"");
        source_split=source_regex.split(">");
      }catch(Error e){
        print("%s\n",e.message);
      }
      //配列からコンストラクタに格納
      source_label=source_split[1];
      source_url=source_split[0];
    }
  
    //urlの解析
    private void parse_urls(Json.Array urls_json_array){
      urls_array=new urls[urls_json_array.get_length()];
      for(int i=0;i<urls_json_array.get_length();i++){
        Json.Object urls_json_obj=urls_json_array.get_object_element(i);
        foreach(string member in urls_json_obj.get_members()){
          switch(member){
            case "display_url":urls_array[i].display_url=urls_json_obj.get_string_member(member);
            break;
            case "expanded_url":urls_array[i].expanded_url=urls_json_obj.get_string_member(member);
            break;
            case "url":urls_array[i].url=urls_json_obj.get_string_member(member);
            break;
            case "indices":
            Json.Array indices_json_array=urls_json_obj.get_array_member(member);
            for(int j=0;j<2;j++){
              switch(j){
                case 0:urls_array[i].start_indices=(int)indices_json_array.get_int_element(j);
                break;
                case 1:urls_array[i].end_indices=(int)indices_json_array.get_int_element(j);
                break;
              }
            }
            break;
          }
        }
      }
    }
    
    //mediaの解析
    private void parse_media(Json.Array media_json_array){
      media_array=new media[media_json_array.get_length()];
      for(int i=0;i<media_json_array.get_length();i++){
        Json.Object media_json_obj=media_json_array.get_object_element(i);
        foreach(string member in media_json_obj.get_members()){
          switch(member){
            case "display_url":media_array[i].display_url=media_json_obj.get_string_member(member);
            break;
            case "expanded_url":media_array[i].expanded_url=media_json_obj.get_string_member(member);
            break;
            case "media_url":media_array[i].media_url=media_json_obj.get_string_member(member);
            break;
            case "media_url_https":media_array[i].media_url_https=media_json_obj.get_string_member(member);
            break;
            case "url":media_array[i].url=media_json_obj.get_string_member(member);
            break;
            case "indices":
            Json.Array indices_json_array=media_json_obj.get_array_member(member);
            for(int j=0;j<2;j++){
              switch(j){
                case 0:media_array[i].start_indices=(int)indices_json_array.get_int_element(j);
                break;
                case 1:media_array[i].end_indices=(int)indices_json_array.get_int_element(j);
                break;
              }
            }
            break;
          }
        }
      }
    }
  }
}