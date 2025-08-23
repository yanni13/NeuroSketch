package com.gtf.neuro_sketch.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
public class ImageAnalysisResult {
    @JsonProperty("detected_objects")
    private List<String> detectedObjects;
    
    @JsonProperty("object_details")
    private List<ObjectDetail> objectDetails;
    
    @JsonProperty("colors_used")
    private List<String> colorsUsed;
    
    @JsonProperty("dominant_colors")
    private List<String> dominantColors;
    
    private Composition composition;
    
    @JsonProperty("drawing_characteristics")
    private DrawingCharacteristics drawingCharacteristics;
    
    @JsonProperty("emotional_indicators")
    private EmotionalIndicators emotionalIndicators;
    
    @JsonProperty("technical_analysis")
    private TechnicalAnalysis technicalAnalysis;
    
    @JsonProperty("overall_impression")
    private OverallImpression overallImpression;

    @Data
    @NoArgsConstructor
    public static class ObjectDetail {
        @JsonProperty("object_name")
        private String objectName;
        private Position position;
        @JsonProperty("visual_characteristics")
        private VisualCharacteristics visualCharacteristics;
        @JsonProperty("spatial_relationships")
        private SpatialRelationships spatialRelationships;
        @JsonProperty("symbolic_indicators")
        private SymbolicIndicators symbolicIndicators;
    }

    @Data
    @NoArgsConstructor
    public static class Position {
        private String location;
        @JsonProperty("relative_size")
        private String relativeSize;
        private String prominence;
    }

    @Data
    @NoArgsConstructor
    public static class VisualCharacteristics {
        private List<String> colors;
        @JsonProperty("line_style")
        private String lineStyle;
        @JsonProperty("detail_level")
        private String detailLevel;
        @JsonProperty("completion_state")
        private String completionState;
    }

    @Data
    @NoArgsConstructor
    public static class SpatialRelationships {
        @JsonProperty("connection_to_others")
        private String connectionToOthers;
        @JsonProperty("interaction_type")
        private String interactionType;
        @JsonProperty("relative_placement")
        private String relativePlacement;
    }

    @Data
    @NoArgsConstructor
    public static class SymbolicIndicators {
        @JsonProperty("traditional_meaning")
        private String traditionalMeaning;
        @JsonProperty("art_therapy_significance")
        private String artTherapySignificance;
        @JsonProperty("contextual_meaning")
        private String contextualMeaning;
        @JsonProperty("emotional_expression")
        private String emotionalExpression;
    }

    @Data
    @NoArgsConstructor
    public static class Composition {
        private String balance;
        @JsonProperty("space_usage")
        private String spaceUsage;
        private String hierarchy;
    }

    @Data
    @NoArgsConstructor
    public static class DrawingCharacteristics {
        @JsonProperty("line_quality")
        private String lineQuality;
        @JsonProperty("drawing_style")
        private String drawingStyle;
        @JsonProperty("pressure_intensity")
        private String pressureIntensity;
    }

    @Data
    @NoArgsConstructor
    public static class EmotionalIndicators {
        @JsonProperty("color_temperature")
        private String colorTemperature;
        @JsonProperty("brightness_level")
        private String brightnessLevel;
        @JsonProperty("contrast_level")
        private String contrastLevel;
    }

    @Data
    @NoArgsConstructor
    public static class TechnicalAnalysis {
        @JsonProperty("completion_level")
        private String completionLevel;
        @JsonProperty("detail_level")
        private String detailLevel;
        private String organization;
    }

    @Data
    @NoArgsConstructor
    public static class OverallImpression {
        @JsonProperty("narrative_quality")
        private String narrativeQuality;
        @JsonProperty("emotional_tone")
        private String emotionalTone;
        @JsonProperty("energy_level")
        private String energyLevel;
    }
}