#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <connectEvent.h>
#include <QQuickView>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ConnectEvent *event = new ConnectEvent();
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    //qrc:/main.qml를 들록한 엔진의 object값을 가져옴
    QObject *root = engine.rootObjects()[0];


    QObject::connect(root, SIGNAL(qmlSignal(int)), event, SLOT(cppslot(int)));
    //QObject::connect(root, SIGNAL(qmlSignal2(QString)), event, SLOT(indexMessage(Qstring)));
    QObject::connect(root, SIGNAL(qmlSignal3(QString)),event, SLOT(cppStringTestMethod(QString)));

    //qrc:/main.qml를 등록한 엔진의 object값을 window타입으로 변경
    event->setWindow(qobject_cast<QQuickWindow*>(root));

    if(engine.rootObjects().isEmpty())
        return -1;

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
