#ifndef CONNECTEVENT_H
#define CONNECTEVENT_H

#include<QQuickView>
#include<QObject>
#include<iostream>

using namespace std;

//connection을 사용하기 위해 상속 받아야 하는 클래스
class ConnectEvent:public QObject
{
public:
    Q_OBJECT //왜 추가해야하는지는 모르겠지만 추가안하면 connection할때 에러뜸
    //Q_OBJECT추가 후 Build->Run qmake를 해주자!
public:
    ConnectEvent();
    ~ConnectEvent();

    //cpp에서 시그널을 날리고 qml에서 받기위해 connection을 해두는 함수
    void cppSignaltoQmlSlot();
    void setWindow(QQuickWindow*Window);

    //함수앞에 Q_INVOKABLE를 선언해서 QML에서 직접 호출이 가능한 함수를 만듬
    Q_INVOKABLE void cppStringTestMethod(QString stringData);
private:
    QQuickWindow* mMainView;
signals://클래스에서 signal등록 하는 방법
    void cppSignaltestData(QVariant);
public slots: //클레스에 slot을 등록
    void cppslot(const int a); //slot 정의
    //필요한 메소드
    void indexMessage(QString str); //slot 정의
};

#endif // CONNECTEVENT_H
