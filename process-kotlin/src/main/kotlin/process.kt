@file:JvmName("Process")
package process

import kotlin.system.exitProcess
import java.lang.System
import java.lang.Exception
import java.io.IOException
import java.io.File
import com.fasterxml.jackson.dataformat.csv.CsvParser
import com.fasterxml.jackson.dataformat.csv.CsvMapper
import com.fasterxml.jackson.databind.ObjectMapper

val OK   = 0
val FAIL = 1

fun printerr(message: Any?) = System.err.println(message)

fun process(field: String, folder: String): Int {
    val histogram = mutableMapOf<String, Int>()

    val files = File(folder).listFiles { file -> file.isFile() && file.getName().endsWith(".json") }
    val jsonMapper = ObjectMapper()
    files?.forEach { file ->
        val data: Map<*, *>
        try {
            data = jsonMapper.readValue(file, Map::class.java)
        } catch (ex: Exception) {
            printerr(ex)
            return FAIL
        }
        val key = data.get(field)
        when (key) {
            null -> {
                printerr("Field is missing")
                return FAIL
            }
            "" -> {}
            is String -> {
                var count = histogram.get(key)?.plus(1) ?: 1
                histogram.put(key, count)
            }
            else -> {
                printerr("Field is not a string")
                return FAIL
            }
        }
    }
    val frequencies = histogram.asSequence().sortedBy {
        kv -> -kv.value
    }.map {
        kv -> arrayOf(kv.key, "${kv.value}")
    }.toList()
    return writeCSV("output.csv", frequencies)
}

fun writeCSV(filename: String, data: List<*>): Int {
    val mapper = CsvMapper()
    mapper.enable(CsvParser.Feature.WRAP_AS_ARRAY)
    val outFile = File(filename)
    try {
        mapper.writeValue(outFile, data)
    } catch (e: IOException) {
        printerr(e)
        return FAIL
    }
    return OK
}

fun main(args: Array<String>) {
    if (2 != args.size) {
        printerr("Args are: <field name> <folder>")
        exitProcess(FAIL)
    } else {
        exitProcess(process(args[0], args[1]))
    }
}

//// Benchmark
//fun main(args: Array<String>) {
//    for (x in 1..100)
//        process("Name", "../test_data/")
//}
