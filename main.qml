import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import "."

Window {
    id:w1
    width: 480
    height: 640
    visible: true
    title: qsTr("리스트 넘기기")

    signal qmlSignal(int op);
    //signal qmlSignal2(msg: string);
    signal qmlSignal3(string str);

    function qmlSlotTestData(data){ //slot으로 등록한 함수
        console.log("qmlSlotTestData : "+data);
    }



    property int depth : 0 //전역변수로 프로그램이 실행됐을때 0으로 세팅

    property int depth1_index : 0
    property int depth2_index : 0

    property int why: 0 //depth0에서 index 담을 변수
    property int why2: 0 //depth1에서 index 담을 변수

    property string test: "A"; //text name
    property int test2: 0; //highlight 높이

    property var depth0: [{"name":"A"},{"name":"B"},{"name":"C"}]
    property var depth1 : [[{"name":"AA"},{"name":"AB"},{"name":"AC"}],
                            [{"name":"BA"},{"name":"BB"}],
                            [{"name":"CA"}]]
    property var depth2 : [
                            [[{"name":"AAA"},{"name":"AAB"},{"name":"AAC"}],
                            [{"name":"ABA"},{"name":"ABB"},{"name":"ABC"}],
                            [{"name":"ACA"},{"name":"ACB"},{"name":"ACC"}]],

                            [[{"name":"BAA"},{"name":"BAB"},{"name":"BAC"}],
                            [{"name":"BBA"},{"name":"BBB"},{"name":"BBC"},{"name":"BBD"}]],

                            [[{"name":"CAA"},{"name":"CAB"},{"name":"CAC"}]]
                          ]

    Rectangle{
        width:240
        height:640
        color:"pink"

        //setup
        //시작 시 최상위 depth 내용 뿌리기
        Component.onCompleted : {
            //왼쪽
            for(var i=0; i<depth0.length ; i++){
                listmodel1.append({"name":depth0[i].name});
            }
            //오른쪽
            for(var j=0; j<depth1[0].length; j++){;
                listmodel2.append({"name":depth1[0][j].name});
            }

            //A의 색을 빨간색으로 해야하는데
            //text_color.color = "red";
        }

        //왼쪽
        ListView{
            id:listview1
            anchors.fill: parent

            highlightFollowsCurrentItem: false

            highlight: Text{
                color:"red"
                text:test
                font.pixelSize: 30
                y:test2
                z:300
            }

            model:listmodel1
            delegate: Component{
                id:del1
                Item{
                    width:240
                    height:100
                    Column{
                        Text{
                            id:text_color
                            text:name
                            font.pixelSize: 30
                        }
                    }
                    MouseArea{
                        anchors.fill: parent

                        onClicked:{
                            listview1.currentIndex = index
                            test2 = listview1.currentItem.y;

                            why = index;

                            console.log("left clicked! depth 는 ? ",depth);

                            //depth 0인경우
                            if(depth === 0){
                                listmodel2.clear(); //오른쪽 다지움
                                for(var i=0; i<depth1[index].length; i++){; //오른쪽에 채워넣음
                                    listmodel2.append({"name":depth1[index][i].name});
                                }
                                test = depth0[index].name;
                                //depth1 highlight에서 쓸꺼임
                                depth1_index = why;//뭔가 문제가 있다..!
                            }else if(depth === 1){
                                listmodel2.clear(); //오른쪽 다지움
                                //오른쪽에 추가
                                for(var j=0; j<depth2[depth1_index][why].length; j++){; //오른쪽에 채워넣음
                                    listmodel2.append({"name":depth2[depth1_index][why][j].name});
                                }
                                //highlight 작업
                                test = depth1[depth1_index][why].name;

                                //depth2 highlight에서 쓸꺼임
                                depth2_index = why;

                            }else if(depth === 2){
                                //highlight 작업
                                test = depth2[depth1_index][depth2_index][why].name;
                            }else{ //depth가 0미만으로 떨어진 경우
                                depth = 0;
                            }
                            w1.qmlSignal3(test); //string값 인자로 cpp에 출력
                        }//end_of_onclicked
                    }
                }

            }
        }
        ListModel{
            id:listmodel1
        }
    }//end_of_leftRectangle

    //rectangle을 2개두는건 맞음 - 왼쪽을 누르느냐 오른쪽을 누르느냐에 따라 하는 일이 달라지기에
    //오른쪽
    Rectangle{
        x:240
        width:240
        height:640
        color:"yellow"
        ListView{
            id:listview2
            anchors.fill: parent
            focus:true

            model:listmodel2
            delegate: Component{
                Item{
                    width:240
                    height:100
                    Column{
                        Text{
                            id:text_color
                            text:name
                            font.pixelSize: 30
                        }
                    }
                    MouseArea{
                        anchors.fill: parent

                        onClicked:{
                            listview2.currentIndex = index; //highlight를 위한
                            test2 = listview2.currentItem.y;

                            depth++;
                            console.log("right clicked! depth는 ? "+depth);
                            why2 = index;

                            //listmodel1 = listmodel2;

                            listmodel1.clear();
                            //오른쪽을 왼쪽으로
                            for(var i=0; i<listmodel2.count; i++){; //왼쪽에 채워넣음
                                listmodel1.append({"name":listmodel2.get(i).name});
                            }

                            //내용 오른쪽에 출력
                            if(depth==1){
                                listmodel2.clear(); //오른쪽 다지움
                                for(var j=0; j<depth2[depth1_index][why2].length; j++){; //왼쪽에 채워넣음
                                    listmodel2.append({"name":depth2[depth1_index][why2][j].name});
                                }
                            }else{

                            }


                            //highlight처리
                            if(depth===1){
                                test = depth1[depth1_index][why2].name;

                                //depth2 highlight에서 쓸꺼임
                                depth2_index = why2;
                            }else if(depth===2){
                                test = listmodel2.get(why2).name;
                                listmodel2.clear(); //오른쪽 다지움
                            }
                            w1.qmlSignal3(test); //string값 인자로 cpp에 출력
                        }//end_of_onclicked
                    }
                }

            }
        }
        ListModel{
            id:listmodel2
            //왼쪽의 리스트하나(delegate) 클릭 시,
            //그것에 해당하는 리스트를 불러올 수 있어야함
        }
    }//end_of_rightRectangle
    Button{
        id:btn
        anchors.bottom: parent.bottom
        width:100
        height:50
        text:"back"
        onClicked: {
            //w1.qmlSignal(1); //int값 인자로 cpp에 출력

            //오른쪽 바꾸기
            listmodel2.clear();
            //왼쪽을 오른쪽으로
            for(var i=0; i<listmodel1.count; i++){; //오른쪽에 채워넣음
                listmodel2.append({"name":listmodel1.get(i).name});
            }
            depth--;
            //depth -1을 받아오기

            //왼쪽 바꾸기
            if(depth===0){
                listmodel1.clear(); //왼쪽 다 지움
                for(var j=0; j<depth0.length; j++){; //왼쪽에 채워넣음
                    listmodel1.append({"name":depth0[j].name});
                }
                test = "";

            }else if(depth===1){
                listmodel1.clear(); //왼쪽 다 지움
                for(var k=0; k<depth1[depth1_index].length; k++){; //왼쪽에 채워넣음
                    listmodel1.append({"name":depth1[depth1_index][k].name});
                }
                test = "";

            }else if(depth===2){

            }else{ //depth가 0미만으로 떨어진 경우
                depth = 0;
                listmodel2.clear();
            }
            console.log("back clicked! depth 는 ? "+depth);
        }
    }

}
