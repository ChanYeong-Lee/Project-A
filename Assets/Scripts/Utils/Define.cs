using System;

public class Define
{
    // 상수(const)
    // 열거형(Enum)
    // 정리

    // 기본 화살 데이터 주소 값
    public const string DefaultArrowDataPath = "ScriptableObject/Item/Arrow/Arrow";
    // 레시피 데이터 주소 값
    public const string RecipeDataPath = "ScriptableObject/Recipe/";

    public const string questDataPath = "ScriptableObject/Quest/";
    
    // Env 성장 시간 : 프래임 * 시간
    public const int GrowthTime = 60 * 10;

    public enum SceneType
    {
        TitleScene,     // 로비 씬
        LoadingScene,   // 로딩 씬
        GameScene,      // 게임 씬
    }
    
    // 아이템
    public enum ItemType
    {
        None,           //
        Arrow,          // 화살 아이템
        Consumption,    // 소모 아이템
        Ingredients,    // 재료 아이템
        Etc
    }
    
    // 화살 속성
    public enum AttributeType
    {
        Default,           // 기본
        Bomb,           // 폭탄 - 다리(하단부) 부위 타격시 이동 중지, 팔(상단부) 부위 타격시 공격 중지
        Electric,       // 전기 - 모든 부위 전부 타격시 일시 마비
        Fire,           // 불 - 도트 데미지, 보스에 따라 내성 유무 차이
        Glue,            // 끈적끈적 - 다리(하단부) 부위 타격시 이동속도 감소, 팔(상단부) 부위 타격시 공격속도 감소 
        Light,          // 빛 - 눈 부위 타격시 일정 시간동안 추적 타켓 놓침
        Poison,         // 독 - 도트 데미지, 보스에 따라 내성 유무 차이
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
        Dead,
    }
    
    public enum BearState
    {
        Idle,
        Think,
        Trace,
        Rush,
        Prowl,
        Attack,
        Roar,
        Dead,
    }
    
    public enum MerchantState
    {
        Idle,
        Wander,
        RunAway,
        Interact,
    }

    public enum Direction
    {
        Up,
        Down,
        Left,
        Right
    }

    public enum QuestState
    {
        RequiredNotMet,
        CanStart,
        InProgress,
        CanFinish,
        Finished
    
    }

}