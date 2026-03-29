import { View, Text, ScrollView, TextInput, Pressable } from "react-native";
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

const PROJECT_TYPES = ["랜딩페이지", "기업 홈페이지", "쇼핑몰", "웹앱", "기타"];

export default function ContactScreen() {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [projectType, setProjectType] = useState("");
  const [description, setDescription] = useState("");

  const handleSubmit = () => {
    // TODO: API 연동
  };

  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1" showsVerticalScrollIndicator={false}>
        {/* 헤더 */}
        <View className="px-5 pt-4 pb-2">
          <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-1">
            CONTACT US
          </Text>
          <Text className="text-2xl font-bold tracking-tight text-gray-900">
            견적 문의
          </Text>
          <Text className="text-body text-gray-400 mt-1">
            프로젝트에 대해 알려주세요
          </Text>
        </View>

        {/* 견적 안내 카드 */}
        <View className="px-5 mt-4 mb-6">
          <View className="sn-quote-card flex-row items-center" style={cardShadow}>
            <View className="w-11 h-11 bg-primary/10 rounded-full items-center justify-center mr-4">
              <Ionicons name="time-outline" size={22} color="#00a859" />
            </View>
            <View className="flex-1">
              <Text className="text-body font-semibold text-primary">무료 견적 안내</Text>
              <Text className="text-caption text-gray-500 mt-0.5 leading-relaxed">
                문의 후 24시간 이내에 견적서를 보내드립니다
              </Text>
            </View>
          </View>
        </View>

        {/* 폼 카드 */}
        <View className="px-5">
          <View className="sn-card" style={cardShadow}>
            {/* 이름 */}
            <View className="mb-5">
              <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
                NAME
              </Text>
              <TextInput
                className="sn-input"
                placeholder="이름을 입력하세요"
                placeholderTextColor="#D1D5DB"
                value={name}
                onChangeText={setName}
              />
            </View>

            {/* 이메일 */}
            <View className="mb-5">
              <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
                EMAIL
              </Text>
              <TextInput
                className="sn-input"
                placeholder="이메일을 입력하세요"
                placeholderTextColor="#D1D5DB"
                keyboardType="email-address"
                autoCapitalize="none"
                value={email}
                onChangeText={setEmail}
              />
            </View>

            {/* 프로젝트 유형 */}
            <View className="mb-5">
              <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
                PROJECT TYPE
              </Text>
              <View className="flex-row flex-wrap gap-2">
                {PROJECT_TYPES.map((type) => (
                  <Pressable
                    key={type}
                    onPress={() => setProjectType(type)}
                    className={`rounded-full px-4 py-2.5 ${
                      projectType === type ? "bg-primary" : "bg-gray-100"
                    }`}
                  >
                    <Text
                      className={`text-caption font-semibold ${
                        projectType === type ? "text-white" : "text-gray-500"
                      }`}
                    >
                      {type}
                    </Text>
                  </Pressable>
                ))}
              </View>
            </View>

            {/* 프로젝트 설명 */}
            <View className="mb-2">
              <Text className="text-eyebrow uppercase tracking-[0.15em] text-gray-400 mb-2 ml-1">
                DESCRIPTION
              </Text>
              <TextInput
                className="sn-input h-32"
                placeholder="프로젝트에 대해 자세히 설명해주세요"
                placeholderTextColor="#D1D5DB"
                multiline
                textAlignVertical="top"
                value={description}
                onChangeText={setDescription}
              />
            </View>
          </View>
        </View>

        {/* 제출 버튼 */}
        <View className="px-5 mt-6 mb-10">
          <Pressable className="sn-btn-primary" style={cardShadow} onPress={handleSubmit}>
            <Text className="sn-btn-primary-text">견적 요청하기</Text>
          </Pressable>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}
