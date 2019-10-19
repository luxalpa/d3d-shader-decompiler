#include "MainWindow.h"
#include "ui_MainWindow.h"
#include <QFile>
#include <QDebug>
#include <QFileDialog>
#include <QMessageBox>

QHash<QString, MainWindow::DecompInstrFunc> MainWindow::commands = MainWindow::buildFunctionList();

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->btnDecompile, SIGNAL(clicked()), this, SLOT(showDecompile()));
}

MainWindow::~MainWindow()
{
    delete ui;
}

QString doError(QString err) {
    qDebug() << err;
    return "// " + err;
}

void MainWindow::decompile(QString source, QString destination)
{
    QFile file(source);
    file.open(QIODevice::ReadOnly);
    QHash<QString, QString> vars;

    QString output;

    while(!file.atEnd()) {
        QString line = file.readLine();
        line = line.trimmed();
        if(line.startsWith("//") || line.isEmpty()) {
            output.append(QString("%1\n").arg(line));
            continue;
        }
        int p = line.indexOf(QChar(' '));
        if(p == -1)
            p = line.size();
        QString instruction = line.left(p);
        QStringList args;
        if(p != line.size()) {
            QString rem = line.mid(p+1);
            args = rem.split(",");
            for(int i = 0; i < args.size(); i++) {
                args[i] = args[i].trimmed();
            }
        }

        QString cmd;
        if(instruction.startsWith("dcl_")) {
            QString varName;
            if(args.size() != 1) {
                cmd = doError(QString("%1 has invalid number of arguments").arg(instruction));
            } else {
                if(instruction == "dcl_normal")
                    varName = "vNormal";
                else if(instruction == "dcl_position")
                    varName = "vPosition";
                else if(instruction == "dcl_blendweight")
                    varName = "vBlendWeight";
                else if(instruction == "dcl_blendindices")
                    varName = "vBlendIndices";
                else if(instruction == "dcl_texcoord")
                    varName = "vTexCoord";
                else if(instruction == "dcl_texcoord1")
                    varName = "vTexCoord1";
                else if(instruction == "dcl_texcoord2")
                    varName = "vTexCoord2";
                else if(instruction == "dcl_texcoord3")
                    varName = "vTexCoord3";
                else if(instruction == "dcl_texcoord4")
                    varName = "vTexCoord4";
                else if(instruction == "dcl_texcoord5")
                    varName = "vTexCoord5";
                else if(instruction == "dcl_texcoord6")
                    varName = "vTexCoord6";
                else if(instruction == "dcl_texcoord7")
                    varName = "vTexCoord7";
                else if(instruction == "dcl_texcoord8")
                    varName = "vTexCoord8";
                else if(instruction == "dcl_texcoord9")
                    varName = "vTexCoord9";
                else if(instruction == "dcl_position1")
                    varName = "vPosition1";
                else if(instruction == "dcl_normal1")
                    varName = "vNormal1";

                if(!varName.isEmpty()) {
                    vars[args[0]] = varName;
                    continue;
                }
            }
        }

        QString suffix;

        if(instruction.endsWith("_sat")) {
            instruction = instruction.left(instruction.indexOf("_sat"));
            suffix = " // CLAMPED";
        }

        // Replace v0 through vPosition etc
        for(int i = 0; i < args.size(); i++) {
            if(vars.contains(args[i]))
                args[i] = vars[args[i]];
        }

        if(!commands.contains(instruction)) {
            cmd = doError("Error: Unknown instruction: " + instruction);
        } else {
            cmd = (commands[instruction])(args) + suffix;
        }

        if(!cmd.startsWith("//"))
            cmd.prepend("    "); // indentation
        output.append(QString("%1\n").arg(cmd));
    }
    file.close();

    QFile outfile(destination);
    outfile.open(QIODevice::WriteOnly);
    outfile.write(output.toAscii());
    outfile.close();
}



#define DECOMPILE_FUNC(name, numArgs, replacement) \
QString d_##name (QStringList args)\
{\
    if(args.size() != numArgs)\
        return doError(QString("Error with %1 instruction!").arg(QString(#name).toUpper()));\
    switch(numArgs) {\
    case 0:\
        return QString(replacement); break;\
    case 1:\
        return QString(replacement).arg(args[0]); break;\
    case 2:\
        return QString(replacement).arg(args[0], args[1]); break;\
    case 3:\
        return QString(replacement).arg(args[0], args[1], args[2]); break;\
    case 4:\
        return QString(replacement).arg(args[0], args[1], args[2], args[3]); break;\
    case 5:\
        return QString(replacement).arg(args[0], args[1], args[2], args[3], args[4]); break;\
    }\
}

#define ADD_DECOMPILE_FUNC(name) list[#name] = d_##name;

QString d_add(QStringList args)
{
    if(args.size() != 3)
        return doError("Error with ADD instruction!");
    if(args[1].startsWith("-")) {
        qSwap(args[1], args[2]);
    }
    if(args[2].startsWith("-"))
        return QString("%1 = %2 - %3").arg(args[0], args[1], args[2].mid(1));
    else
        return QString("%1 = %2 + %3").arg(args[0], args[1], args[2]);
}

QString d_mad(QStringList args)
{
    if(args.size() != 4) {
        return doError("Error with MAD instruction!");
    }
    if(args[3].startsWith("-"))
        return QString("%1 = %2 * %3 - %4").arg(args[0], args[1], args[2], args[3].mid(1));
    else
        return QString("%1 = %2 * %3 + %4").arg(args[0], args[1], args[2], args[3]);
}

DECOMPILE_FUNC(vs_2_0, 0, "// Vertex Shader 2.0")
DECOMPILE_FUNC(ps_3_0, 0, "// Pixel Shader 3.0")
DECOMPILE_FUNC(def, 5, "vec4 %1(%2, %3, %4, %5)")
DECOMPILE_FUNC(abs, 2, "%1 = abs(%2)")
DECOMPILE_FUNC(slt, 3, "%1 = (%2 < %3) ? 1 : 0")
DECOMPILE_FUNC(mul, 3, "%1 = %2 * %3")
DECOMPILE_FUNC(mov, 2, "%1 = %2")
DECOMPILE_FUNC(mova, 2, "%1 = %2")
DECOMPILE_FUNC(nrm, 2, "%1 = normalize(%2)")
DECOMPILE_FUNC(dp3, 3, "%1 = dot(%2.xyz, %3.xyz)")
DECOMPILE_FUNC(dp4, 3, "%1 = dot(%2, %3)")
DECOMPILE_FUNC(min, 3, "%1 = min(%2, %3)")
DECOMPILE_FUNC(max, 3, "%1 = max(%2, %3)")
DECOMPILE_FUNC(rcp, 2, "%1 = 1/%2")
DECOMPILE_FUNC(log, 2, "%1 = log2(%2)")
DECOMPILE_FUNC(exp, 2, "%1 = pow(2, %2)")
DECOMPILE_FUNC(rsq, 2, "%1 = inversesqrt(%2)")
DECOMPILE_FUNC(texld, 3, "%1 = texture2D(%3, %2)")
DECOMPILE_FUNC(texldp, 3, "%1 = texture2D(%3, %2/%2.w)")
DECOMPILE_FUNC(dcl_2d, 1, "Sampler2D %1")
DECOMPILE_FUNC(cmp, 4, "%1 = %2 >= 0 ? %3 : %4")
DECOMPILE_FUNC(lrp, 4, "%1 = mix(%3, %4, %2)")
DECOMPILE_FUNC(pow, 3, "%1 = pow(%2, %3)")


QHash<QString, MainWindow::DecompInstrFunc> MainWindow::buildFunctionList()
{
    QHash<QString, DecompInstrFunc> list;

    ADD_DECOMPILE_FUNC(vs_2_0);
    ADD_DECOMPILE_FUNC(ps_3_0);
    ADD_DECOMPILE_FUNC(slt);
    ADD_DECOMPILE_FUNC(abs);
    ADD_DECOMPILE_FUNC(add);
    ADD_DECOMPILE_FUNC(def);
    ADD_DECOMPILE_FUNC(mov);
    ADD_DECOMPILE_FUNC(mova);
    ADD_DECOMPILE_FUNC(mul);
    ADD_DECOMPILE_FUNC(mad);
    ADD_DECOMPILE_FUNC(nrm);
    ADD_DECOMPILE_FUNC(dp3);
    ADD_DECOMPILE_FUNC(dp4);
    ADD_DECOMPILE_FUNC(min);
    ADD_DECOMPILE_FUNC(max);
    ADD_DECOMPILE_FUNC(rcp);
    ADD_DECOMPILE_FUNC(log);
    ADD_DECOMPILE_FUNC(exp);
    ADD_DECOMPILE_FUNC(rsq);
    ADD_DECOMPILE_FUNC(texld);
    ADD_DECOMPILE_FUNC(texldp);
    ADD_DECOMPILE_FUNC(dcl_2d);
    ADD_DECOMPILE_FUNC(cmp);
    ADD_DECOMPILE_FUNC(lrp);
    ADD_DECOMPILE_FUNC(pow);

    return list;
}

void MainWindow::showDecompile()
{
    QString from = QFileDialog::getOpenFileName(this, "Source File");
    if(from.isEmpty())
        return;
    QString target = QFileDialog::getSaveFileName(this, "Destination File");
    if(target.isEmpty())
        return;
    decompile(from, target);
//    QMessageBox::information(this, "Converted!");
}
