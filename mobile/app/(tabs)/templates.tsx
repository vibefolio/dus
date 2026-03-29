import { View, Text, ScrollView, Pressable } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { useState } from "react";
import { Ionicons } from "@expo/vector-icons";

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

const CATEGORIES = ["전체", "랜딩페이지", "포트폴리오", "이커머스", "블로그", "대시보드"];

const TEMPLATES = [
  { id: 1, name: "비즈니스 랜딩페이지", category: "랜딩페이지", price: "₩150,000" },
  { id: 2, name: "포트폴리오 사이트", category: "포트폴리오", price: "₩120,000" },
  { id: 3, name: "쇼핑몰 템플릿", category: "이커머스", price: "₩250,000" },
  { id: 4, name: "블로그 테마", category: "블로그", price: "₩80,000" },
  { id: 5, name: "SaaS 대시보드", category: "대시보드", price: "₩300,000" },
  { id: 6, name: "스타트업 랜딩", category: "랜딩페이지", price: "₩180,000" },
];

export default function TemplatesScreen() {
  const [selected, setSelected] = useState("전체");

  const filtered =
    selected === "전체"
      ? TEMPLATES
      : TEMPLATES.filter((t) => t.category === selected);

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      {/* 헤더 */}
      <View className="px-5 pt-4 pb-2">
        <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
          BROWSE
        </Text>
        <Text className="text-2xl font-bold tracking-tight text-gray-900">
          템플릿
        </Text>
        <Text className="text-body text-gray-400 mt-1">
          디자인 템플릿을 둘러보세요
        </Text>
      </View>

      {/* 카테고리 칩 필터 */}
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        className="mt-2 mb-4"
        contentContainerStyle={{ paddingHorizontal: 20, gap: 8 }}
      >
        {CATEGORIES.map((cat) => (
          <Pressable
            key={cat}
            onPress={() => setSelected(cat)}
            className={`rounded-full px-4 py-2.5 ${
              selected === cat ? "bg-primary" : "bg-white"
            }`}
            style={selected !== cat ? cardShadow : undefined}
          >
            <Text
              className={`text-caption font-semibold ${
                selected === cat ? "text-white" : "text-gray-500"
              }`}
            >
              {cat}
            </Text>
          </Pressable>
        ))}
      </ScrollView>

      {/* 템플릿 그리드 (2열) */}
      <ScrollView
        className="flex-1 px-5"
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 24 }}
      >
        <View className="flex-row flex-wrap" style={{ gap: 12 }}>
          {filtered.map((template) => (
            <View
              key={template.id}
              className="sn-template-card"
              style={{ ...cardShadow, width: "48%" as any }}
            >
              {/* 썸네일 */}
              <View className="bg-gray-100 rounded-2xl h-28 mb-3 items-center justify-center">
                <Ionicons name="image-outline" size={28} color="#D1D5DB" />
              </View>
              <Text className="text-body font-semibold text-gray-900" numberOfLines={1}>
                {template.name}
              </Text>
              <Text className="text-caption text-gray-400 mt-0.5">
                {template.category}
              </Text>
              <View className="sn-badge self-start mt-2">
                <Text className="sn-badge-text">{template.price}</Text>
              </View>
            </View>
          ))}
        </View>

        {filtered.length === 0 && (
          <View className="items-center justify-center py-20">
            <Text className="text-4xl mb-4">📋</Text>
            <Text className="text-heading-3 text-gray-900 mb-2">
              템플릿이 없습니다
            </Text>
            <Text className="text-body text-gray-400">
              해당 카테고리에 템플릿이 없습니다
            </Text>
          </View>
        )}
      </ScrollView>
    </SafeAreaView>
  );
}
