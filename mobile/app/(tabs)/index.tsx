import { View, Text, ScrollView, Pressable } from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { Link } from "expo-router";
import { Ionicons } from "@expo/vector-icons";

/* 카드 shadow */
const cardShadow = {
  shadowColor: "#000",
  shadowOffset: { width: 0, height: 2 },
  shadowOpacity: 0.06,
  shadowRadius: 12,
  elevation: 3,
};

/* 인기 템플릿 더미 데이터 */
const POPULAR_TEMPLATES = [
  { id: 1, name: "비즈니스 랜딩페이지", category: "랜딩페이지", price: "₩150,000" },
  { id: 2, name: "포트폴리오 사이트", category: "포트폴리오", price: "₩120,000" },
  { id: 3, name: "쇼핑몰 템플릿", category: "이커머스", price: "₩250,000" },
  { id: 4, name: "블로그 테마", category: "블로그", price: "₩80,000" },
];

/* 서비스 소개 */
const SERVICES = [
  { icon: "color-palette-outline" as const, title: "맞춤 디자인", desc: "브랜드에 맞는 디자인" },
  { icon: "code-slash-outline" as const, title: "퍼블리싱", desc: "반응형 웹 개발" },
  { icon: "rocket-outline" as const, title: "런칭 지원", desc: "배포부터 운영까지" },
];

export default function HomeScreen() {
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>
        {/* 헤더 */}
        <View className="px-5 pt-4 pb-2">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
            DESIGN MARKETPLACE
          </Text>
          <Text className="text-2xl font-bold tracking-tight text-gray-900">
            DUS
          </Text>
        </View>

        {/* 환영 배너 */}
        <View className="px-5 mt-2 mb-6">
          <View className="sn-card bg-primary" style={cardShadow}>
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-white/60 mb-2">
              WELCOME
            </Text>
            <Text className="text-heading-3 text-white">
              원하는 디자인, 쉽고 빠르게
            </Text>
            <Text className="text-body text-white/80 mt-2 leading-relaxed">
              검증된 템플릿으로 웹사이트를 시작하세요.{"\n"}
              맞춤 견적도 무료로 받아보세요.
            </Text>
            <Link href="/contact" asChild>
              <Pressable className="bg-white/20 rounded-full py-3 px-5 mt-4 self-start flex-row items-center">
                <Text className="text-white text-body font-semibold mr-1">
                  무료 견적 받기
                </Text>
                <Ionicons name="arrow-forward" size={16} color="#FFFFFF" />
              </Pressable>
            </Link>
          </View>
        </View>

        {/* 서비스 소개 카드 */}
        <View className="px-5 mb-6">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-3">
            OUR SERVICES
          </Text>
          <View className="flex-row gap-3">
            {SERVICES.map((svc) => (
              <View key={svc.title} className="flex-1 sn-card items-center py-5" style={cardShadow}>
                <View className="w-11 h-11 bg-primary/10 rounded-full items-center justify-center mb-2.5">
                  <Ionicons name={svc.icon} size={20} color="#00a859" />
                </View>
                <Text className="text-caption font-semibold text-gray-900 mb-0.5">{svc.title}</Text>
                <Text className="text-xs text-gray-400">{svc.desc}</Text>
              </View>
            ))}
          </View>
        </View>

        {/* 인기 템플릿 — 가로 스크롤 */}
        <View className="mb-6">
          <View className="px-5 flex-row items-center justify-between mb-3">
            <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400">
              POPULAR TEMPLATES
            </Text>
            <Link href="/templates" asChild>
              <Pressable>
                <Text className="text-primary text-caption font-bold">전체보기</Text>
              </Pressable>
            </Link>
          </View>

          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{ paddingHorizontal: 20, gap: 12 }}
          >
            {POPULAR_TEMPLATES.map((template) => (
              <View
                key={template.id}
                className="sn-template-card w-64"
                style={cardShadow}
              >
                {/* 썸네일 영역 */}
                <View className="bg-gray-100 rounded-2xl h-36 mb-3 items-center justify-center">
                  <Ionicons name="image-outline" size={32} color="#D1D5DB" />
                </View>
                <Text className="text-heading-3 text-gray-900">{template.name}</Text>
                <View className="flex-row items-center justify-between mt-2">
                  <Text className="text-caption text-gray-400">{template.category}</Text>
                  <View className="sn-badge">
                    <Text className="sn-badge-text">{template.price}</Text>
                  </View>
                </View>
              </View>
            ))}
          </ScrollView>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
