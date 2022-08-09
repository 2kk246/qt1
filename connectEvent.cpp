#include "connectEvent.h"

ConnectEvent::ConnectEvent()
{
    cout<<"ConnectEvent"<<endl;
}
ConnectEvent::~ConnectEvent()
{

}

void ConnectEvent::cppSignaltoQmlSlot()
{
    //시그널과 슬롯을 연결해주는 connection
    QObject::connect(this, SIGNAL(cppSignaltestData(QVariant)), mMainView, SLOT(qmlSlotTestData(QVariant)));

    //cpp에서 시그널을 호출하는 부분 매개변수에 3을 넣어서 3이 qml함수에 전달된다
    emit cppSignaltestData("cpp to qml");

    //qml쪽으로 방출
    //cpp->qml에 데이터를 전송하면 서버에서 받아오는 값들이나 db에서 받아오는 값들을
    //cpp에서 저장한 후 qml에 전송해서 그 값으로 ui를 출력할 수 있는 프로그램을 만들 수 있다.
};

void ConnectEvent::cppslot(const int a)
{
   //slgnal을 통해 받은 a,b를 이용하여
   //slot을 구현하는 부분
    cout << "cppslot : " << a <<endl;

}

void ConnectEvent::indexMessage(QString str){
    cout << "indexMessage : " << str.toStdString() << endl;
}

void ConnectEvent::setWindow(QQuickWindow*Window)
{
    mMainView = Window;//connection을 해주기 위해 윈도우를 등록

    cppSignaltoQmlSlot();//윈도우 등록과 동시에 connection등록
}

//qm소스코드에서 클래스를 등록해서 클래스의 함수를 직접 호출하는 함수
void ConnectEvent::cppStringTestMethod(QString stringData)
{
    cout << "cppStringTestMethod call"<<endl;
    std::string data_str = stringData.toStdString(); //QVariant를 std::string으로 변환
    cout << data_str << endl;
}
