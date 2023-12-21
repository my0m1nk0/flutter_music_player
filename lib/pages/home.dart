import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/colors.dart';
import 'package:music_player/controllers/player_controller.dart';
import 'package:music_player/pages/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.search,color: whiteColor,))
        ],
        leading: const Icon(Icons.sort_rounded,color: whiteColor,),
        title:const Text('Beats',
        style:TextStyle(
          fontSize: 14,
          color: whiteColor,
        ),),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ListView.builder(
      //     physics: const BouncingScrollPhysics(),
      //     itemCount: 100,
      //     itemBuilder: (BuildContext content,int index){
      //       return Container(
      //         margin: const EdgeInsets.only(bottom: 4),
      //         child: ListTile(
      //           tileColor: bgColor,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(12),
      //           ),
      //           textColor: bgColor,
      //           title: const Text("Music Name",
      //           style: TextStyle(
      //             fontSize: 15,
      //             color: whiteColor,
      //           ),
      //           ),
      //           subtitle:const Text(
      //             'Artist Name',
      //             style: TextStyle(
      //               fontSize: 12,
      //               color: whiteColor,
      //             ),
      //           ),
      //           leading: const Icon(Icons.music_note,color: whiteColor,size: 32,),
      //           trailing: const Icon(Icons.play_arrow,color: whiteColor,size: 25,),
      //         ),
      //       );
      //     }
      //   ),
      // ),

      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: (BuildContext context, snapshot){
          if(snapshot.data == null){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.data!.isEmpty){
            return const Center(
              child: Text(
                "No Song found",
                style: TextStyle(
                  fontSize: 14,
                  color: whiteColor,
                ),
              ),
            );
          }else{
            return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext content,int index){
                      return Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child:Obx(
                            () =>
                         ListTile(
                          tileColor: bgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textColor: bgColor,
                          title: Text(
                            snapshot.data![index].displayNameWOExt,
                          style: const TextStyle(
                            fontSize: 15,
                            color: whiteColor,
                          ),
                          ),
                          subtitle: Text(
                            "${snapshot.data![index].artist}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: whiteColor,
                            ),
                          ),
                          leading: QueryArtworkWidget(id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whiteColor,
                            size: 32,
                          ),),
                          trailing: controller.playIndex.value == index && controller.isPlaying.value ? const Icon(Icons.play_arrow,color: whiteColor,size: 26,)
                          : null ,
                          onTap: (){
                            Get.to(()=> Player(data: snapshot.data!,),
                            transition: Transition.downToUp);
                            controller.playSong(snapshot.data![index].uri,index);
                          },
                        ),
                        )
                      );
                    }
                  ),
                );
          }
        },
      ),
    );
  }
}
