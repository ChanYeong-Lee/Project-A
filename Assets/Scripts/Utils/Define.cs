using System;

public class Define
{
    // 상수(const)
    // 열거형(Enum)
    // 정리

    // 레시피 데이터 주소 값
    public const string RecipeDataPath = "ScriptableObject/Recipe/";
    
    // Env 성장 시간 : 프래임 * 시간
    public const int GrowthTime = 60 * 10;

    public enum SceneType
    {
        LobbyScene,     // 로비 씬
        GameScene,      // 게임 씬
    }
    
    // 아이템
    public enum ItemType
    {
        None,           //
        Equipment,      // 장비 아이템
        Consumption,    // 소모 아이템
        Etc
    }
    
    // 화살 속성
    public enum AttributeType
    {
        None,           // 기본
        Light,          // 빛 - 눈 부위 타격시 일정 시간동안 추적 타켓 놓침
        Bomb,           // 폭탄 - 다리(하단부) 부위 타격시 이동 중지, 팔(상단부) 부위 타격시 공격 중지
        Glue,            // 끈적끈적 - 다리(하단부) 부위 타격시 이동속도 감소, 팔(상단부) 부위 타격시 공격속도 감소 
        Poison,         // 독 - 도트 데미지, 보스에 따라 내성 유무 차이
        Fire,           // 불 - 도트 데미지, 보스에 따라 내성 유무 차이
        Electric,       // 전기 - 모든 부위 전부 타격시 일시 마비
        Etc
    }
    
    // 파밍 타입
    public enum FarmingType
    {
        None,           // 기본
        Gathering,      // 채집
        Felling,        // 벌목
        Mining,         // 채광
        Dismantling     // 분해(몬스터 채집)
    }
    
    // Moose State
    public enum MooseState
    {
        Idle,
        Patrol,
        Run,
        TakeAttack,
        Trace,
        Attack,
    }
    public enum MerchantState
    {
        Idle,
        Wander,
        RunAway,
        Interact,
    }

}