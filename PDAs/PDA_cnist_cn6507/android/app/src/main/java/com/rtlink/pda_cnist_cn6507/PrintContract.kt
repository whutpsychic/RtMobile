package com.rtlink.pda_cnist_cn6507

import android.bld.print.configuration.PrintConfig
import android.content.Context
import com.example.lc_print_sdk.PrintUtil

class PrintContract(private val mContext: Context?, private val pUtil: PrintUtil) {
    fun printInit() {
        // 编码模式
        // pUtil.setEncoding("GB2312");
        // 打印布局（居中）
        // pUtil.printAlignment(ALIGN_MODE.ALIGN_CENTER);
        // pUtil.printEnableCertificate(true);
        // pUtil.printAutoEnableMark(true);
        // pUtil.printLanguage(15);
        // pUtil.printEncode(3);
        // pUtil.printFontSize(MODE_ENLARGE.NORMAL);
        // pUtil.printTextBold (true);
        // pUtil.getVersion();
        PrintUtil.printEnableMark(true)
    }

    fun printBarcode(text: String?) {
        PrintUtil.printBarcode(
            PrintConfig.Align.ALIGN_CENTER,
            100,
            text,
            PrintConfig.BarCodeType.TOP_TYPE_CODE128,
            PrintConfig.HRIPosition.POSITION_BELOW
        )
        PrintUtil.start()
    }

    fun printQRcode(text: String?) {
        // pUtil.printQR(PrintConfig.Align.ALIGN_CENTER, 200, text);
        PrintUtil.printQR(PrintConfig.Align.ALIGN_CENTER, 160, text)
//        PrintUtil.printText(
//            PrintConfig.Align.ALIGN_CENTER,
//            PrintConfig.FontSize.TOP_FONT_SIZE_MIDDLE,
//            true,
//            false,
//            text
//        )
        // pUtil.printLine(5);
//        PrintUtil.printLine(1)
        PrintUtil.start()
        // pUtil.printText(text);
        // pUtil.printLine(7);
    }
}