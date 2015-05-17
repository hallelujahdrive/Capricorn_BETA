using Cairo;
using Gdk;
using Gtk;
using Rest;
using Ruribitaki;

using URIUtil;

[GtkTemplate(ui="/org/gtk/capricorn/ui/node.ui")]
public class Node:Grid{
  //メンバ
  protected Ruribitaki.Status status;
  protected unowned CapricornAccount cpr_account;
  protected weak Config config;
  protected weak SignalPipe signal_pipe;
  
  public string id_str;
  public string screen_name;
  
  protected NodeType node_type=NodeType.DEFAULT;
  
  //Widget
  private HeaderDrawingBox header_drawing_box;
  private TextDrawingBox text_drawing_box;
  private FooterDrawingBox footer_drawing_box;
  
  private ProfileImageButton profile_image_button;
  
  [GtkChild]
  protected Box profile_image_box;
  
  [GtkChild]
  protected Box action_box;
  
  public Node(Ruribitaki.Status status,CapricornAccount cpr_account,Config config,SignalPipe signal_pipe){
    this.status=status;
    this.cpr_account=cpr_account;
    this.config=config;
    this.signal_pipe=signal_pipe;
    
    id_str=this.status.id_str;
    screen_name=this.status.user.screen_name;
    
    //NodeTypeの設定
    if(status.is_mine){
      node_type=NodeType.MINE;
    }else if(status.is_reply){
      node_type=NodeType.REPLY;
    }
    
    header_drawing_box=new HeaderDrawingBox(this.status.user,this.config,this.signal_pipe);
    text_drawing_box=new TextDrawingBox(this.status,this.cpr_account,this.config,this.signal_pipe);
    footer_drawing_box=new FooterDrawingBox(this.status,this.config,this.signal_pipe);
    
    profile_image_button=new ProfileImageButton(this.status.user,this.config,this.signal_pipe);
    
    this.attach(header_drawing_box,1,0,1,1);
    this.attach(text_drawing_box,1,1,1,1);
    this.attach(footer_drawing_box,1,3,1,1);
    
    profile_image_box.pack_start(profile_image_button,false,false,0);
        
    //背景色の設定
    set_bg_color();
    
    //シグナルハンドラ
    //背景色設定のシグナル
    this.signal_pipe.color_change_event.connect(()=>{
      set_bg_color();
      this.queue_draw();
    });
  }
  
  //背景色の設定
  protected void set_bg_color(){
    switch(node_type){
      case NodeType.DELETED:this.override_background_color(StateFlags.NORMAL,config.color_profile.delete_bg_rgba);
      break;
      case NodeType.MINE:this.override_background_color(StateFlags.NORMAL,config.color_profile.mine_bg_rgba);
      break;
      case NodeType.REPLY:this.override_background_color(StateFlags.NORMAL,config.color_profile.reply_bg_rgba);
      break;
      case NodeType.RETWEET:this.override_background_color(StateFlags.NORMAL,config.color_profile.retweet_bg_rgba);
      break;
      default:this.override_background_color(StateFlags.NORMAL,config.color_profile.default_bg_rgba);
      break;
    }
  }
}
