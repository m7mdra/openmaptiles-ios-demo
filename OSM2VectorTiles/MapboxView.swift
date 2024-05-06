import SwiftUI
import MapboxMaps
import MapboxCoreMaps
import MapboxCommon
import OSLog

struct MapboxView: UIViewRepresentable {

    
    var oslog = OSLog(subsystem: "MapView", category: "MapView")
    private let mapView = MapView(frame: .zero)
    

    func makeUIView(context: Context) -> MapView {
        return mapView
    }
    
    func updateUIView(_ uiView: MapboxMaps.MapView, context: Context) {
        let styleUrl = Bundle.main.url(forResource: "geography-class-local", withExtension: "json", subdirectory: "styles")!
        let spriteUrl = Bundle.main.url(forResource: "bright-v8", withExtension: nil, subdirectory: "sprites")
        let _ = Bundle.main.url(forResource: "geography-class", withExtension: "mbtiles")
        let glyphsUrl = Bundle.main.url(forResource: "glyphs", withExtension: nil)
        let url5 = Bundle.main.url(forResource: "geography-class.osm2vectortiles", withExtension: nil)
        var data = try! JSONDecoder().decode(LocalStyle.self, from: Data(contentsOf: styleUrl))
        data.glyphs = "\(glyphsUrl!.absoluteString){fontstack}/{range}.pbf"
        data.sprite = spriteUrl!.absoluteString
        data.sources = LocalStyle.Sources(countries:LocalStyle.Countries(type: "vector",
                                                                         bounds: [
                                                                            -180,
                                                                             -85.051129,
                                                                             180,
                                                                             85.051129
                                                                         ],
                                                                         minzoom: 0,
                                                                         maxzoom: 7,
                                                                         tiles: ["\(url5!){z}/{x}/{y}.pbf"]))
        let jsonStyleData = String(data: try! JSONEncoder().encode(data),encoding: .utf8)!
        uiView.mapboxMap.styleJSON = jsonStyleData
        
        // For some reason this dose not work, the style loads but spirte directory is not found by sdk
//        uiView.mapboxMap.styleURI = StyleURI(url: styleUrl)!
        
    }
    
    func makeCoordinator() -> MapboxView.Coordinator {
        Coordinator()
    }
 
}
