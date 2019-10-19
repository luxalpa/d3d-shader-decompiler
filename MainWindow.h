#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QHash>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    typedef QString (*DecompInstrFunc)(QStringList args);

    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    void decompile(QString source, QString destination);
    static QHash<QString, DecompInstrFunc> buildFunctionList();

    static QHash<QString, DecompInstrFunc> commands;

public slots:
    void showDecompile();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
